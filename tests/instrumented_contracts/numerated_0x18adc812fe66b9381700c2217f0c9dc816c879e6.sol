1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId,
86         bytes calldata data
87     ) external;
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
91      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must exist and be owned by `from`.
98      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
99      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
100      *
101      * Emits a {Transfer} event.
102      */
103     function safeTransferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
113      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
114      * understand this adds an external call which potentially creates a reentrancy vulnerability.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
176 
177 
178 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
237 
238 pragma solidity ^0.8.1;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      *
261      * [IMPORTANT]
262      * ====
263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
264      *
265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
267      * constructor.
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize/address.code.length, which returns 0
272         // for contracts in construction, since the code is only stored at the end
273         // of the constructor execution.
274 
275         return account.code.length > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         (bool success, ) = recipient.call{value: amount}("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain `call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
425      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
426      *
427      * _Available since v4.8._
428      */
429     function verifyCallResultFromTarget(
430         address target,
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal view returns (bytes memory) {
435         if (success) {
436             if (returndata.length == 0) {
437                 // only check isContract if the call was successful and the return data is empty
438                 // otherwise we already know that it was a contract
439                 require(isContract(target), "Address: call to non-contract");
440             }
441             return returndata;
442         } else {
443             _revert(returndata, errorMessage);
444         }
445     }
446 
447     /**
448      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
449      * revert reason or using the provided one.
450      *
451      * _Available since v4.3._
452      */
453     function verifyCallResult(
454         bool success,
455         bytes memory returndata,
456         string memory errorMessage
457     ) internal pure returns (bytes memory) {
458         if (success) {
459             return returndata;
460         } else {
461             _revert(returndata, errorMessage);
462         }
463     }
464 
465     function _revert(bytes memory returndata, string memory errorMessage) private pure {
466         // Look for revert reason and bubble it up if present
467         if (returndata.length > 0) {
468             // The easiest way to bubble the revert reason is using memory via assembly
469             /// @solidity memory-safe-assembly
470             assembly {
471                 let returndata_size := mload(returndata)
472                 revert(add(32, returndata), returndata_size)
473             }
474         } else {
475             revert(errorMessage);
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/Context.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev Provides information about the current execution context, including the
489  * sender of the transaction and its data. While these are generally available
490  * via msg.sender and msg.data, they should not be accessed in such a direct
491  * manner, since when dealing with meta-transactions the account sending and
492  * paying for execution may not be the actual sender (as far as an application
493  * is concerned).
494  *
495  * This contract is only required for intermediate, library-like contracts.
496  */
497 abstract contract Context {
498     function _msgSender() internal view virtual returns (address) {
499         return msg.sender;
500     }
501 
502     function _msgData() internal view virtual returns (bytes calldata) {
503         return msg.data;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/math/Math.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Standard math utilities missing in the Solidity language.
516  */
517 library Math {
518     enum Rounding {
519         Down, // Toward negative infinity
520         Up, // Toward infinity
521         Zero // Toward zero
522     }
523 
524     /**
525      * @dev Returns the largest of two numbers.
526      */
527     function max(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a > b ? a : b;
529     }
530 
531     /**
532      * @dev Returns the smallest of two numbers.
533      */
534     function min(uint256 a, uint256 b) internal pure returns (uint256) {
535         return a < b ? a : b;
536     }
537 
538     /**
539      * @dev Returns the average of two numbers. The result is rounded towards
540      * zero.
541      */
542     function average(uint256 a, uint256 b) internal pure returns (uint256) {
543         // (a + b) / 2 can overflow.
544         return (a & b) + (a ^ b) / 2;
545     }
546 
547     /**
548      * @dev Returns the ceiling of the division of two numbers.
549      *
550      * This differs from standard division with `/` in that it rounds up instead
551      * of rounding down.
552      */
553     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
554         // (a + b - 1) / b can overflow on addition, so we distribute.
555         return a == 0 ? 0 : (a - 1) / b + 1;
556     }
557 
558     /**
559      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
560      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
561      * with further edits by Uniswap Labs also under MIT license.
562      */
563     function mulDiv(
564         uint256 x,
565         uint256 y,
566         uint256 denominator
567     ) internal pure returns (uint256 result) {
568         unchecked {
569             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
570             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
571             // variables such that product = prod1 * 2^256 + prod0.
572             uint256 prod0; // Least significant 256 bits of the product
573             uint256 prod1; // Most significant 256 bits of the product
574             assembly {
575                 let mm := mulmod(x, y, not(0))
576                 prod0 := mul(x, y)
577                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
578             }
579 
580             // Handle non-overflow cases, 256 by 256 division.
581             if (prod1 == 0) {
582                 return prod0 / denominator;
583             }
584 
585             // Make sure the result is less than 2^256. Also prevents denominator == 0.
586             require(denominator > prod1);
587 
588             ///////////////////////////////////////////////
589             // 512 by 256 division.
590             ///////////////////////////////////////////////
591 
592             // Make division exact by subtracting the remainder from [prod1 prod0].
593             uint256 remainder;
594             assembly {
595                 // Compute remainder using mulmod.
596                 remainder := mulmod(x, y, denominator)
597 
598                 // Subtract 256 bit number from 512 bit number.
599                 prod1 := sub(prod1, gt(remainder, prod0))
600                 prod0 := sub(prod0, remainder)
601             }
602 
603             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
604             // See https://cs.stackexchange.com/q/138556/92363.
605 
606             // Does not overflow because the denominator cannot be zero at this stage in the function.
607             uint256 twos = denominator & (~denominator + 1);
608             assembly {
609                 // Divide denominator by twos.
610                 denominator := div(denominator, twos)
611 
612                 // Divide [prod1 prod0] by twos.
613                 prod0 := div(prod0, twos)
614 
615                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
616                 twos := add(div(sub(0, twos), twos), 1)
617             }
618 
619             // Shift in bits from prod1 into prod0.
620             prod0 |= prod1 * twos;
621 
622             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
623             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
624             // four bits. That is, denominator * inv = 1 mod 2^4.
625             uint256 inverse = (3 * denominator) ^ 2;
626 
627             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
628             // in modular arithmetic, doubling the correct bits in each step.
629             inverse *= 2 - denominator * inverse; // inverse mod 2^8
630             inverse *= 2 - denominator * inverse; // inverse mod 2^16
631             inverse *= 2 - denominator * inverse; // inverse mod 2^32
632             inverse *= 2 - denominator * inverse; // inverse mod 2^64
633             inverse *= 2 - denominator * inverse; // inverse mod 2^128
634             inverse *= 2 - denominator * inverse; // inverse mod 2^256
635 
636             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
637             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
638             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
639             // is no longer required.
640             result = prod0 * inverse;
641             return result;
642         }
643     }
644 
645     /**
646      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
647      */
648     function mulDiv(
649         uint256 x,
650         uint256 y,
651         uint256 denominator,
652         Rounding rounding
653     ) internal pure returns (uint256) {
654         uint256 result = mulDiv(x, y, denominator);
655         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
656             result += 1;
657         }
658         return result;
659     }
660 
661     /**
662      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
663      *
664      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
665      */
666     function sqrt(uint256 a) internal pure returns (uint256) {
667         if (a == 0) {
668             return 0;
669         }
670 
671         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
672         //
673         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
674         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
675         //
676         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
677         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
678         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
679         //
680         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
681         uint256 result = 1 << (log2(a) >> 1);
682 
683         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
684         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
685         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
686         // into the expected uint128 result.
687         unchecked {
688             result = (result + a / result) >> 1;
689             result = (result + a / result) >> 1;
690             result = (result + a / result) >> 1;
691             result = (result + a / result) >> 1;
692             result = (result + a / result) >> 1;
693             result = (result + a / result) >> 1;
694             result = (result + a / result) >> 1;
695             return min(result, a / result);
696         }
697     }
698 
699     /**
700      * @notice Calculates sqrt(a), following the selected rounding direction.
701      */
702     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
703         unchecked {
704             uint256 result = sqrt(a);
705             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
706         }
707     }
708 
709     /**
710      * @dev Return the log in base 2, rounded down, of a positive value.
711      * Returns 0 if given 0.
712      */
713     function log2(uint256 value) internal pure returns (uint256) {
714         uint256 result = 0;
715         unchecked {
716             if (value >> 128 > 0) {
717                 value >>= 128;
718                 result += 128;
719             }
720             if (value >> 64 > 0) {
721                 value >>= 64;
722                 result += 64;
723             }
724             if (value >> 32 > 0) {
725                 value >>= 32;
726                 result += 32;
727             }
728             if (value >> 16 > 0) {
729                 value >>= 16;
730                 result += 16;
731             }
732             if (value >> 8 > 0) {
733                 value >>= 8;
734                 result += 8;
735             }
736             if (value >> 4 > 0) {
737                 value >>= 4;
738                 result += 4;
739             }
740             if (value >> 2 > 0) {
741                 value >>= 2;
742                 result += 2;
743             }
744             if (value >> 1 > 0) {
745                 result += 1;
746             }
747         }
748         return result;
749     }
750 
751     /**
752      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
753      * Returns 0 if given 0.
754      */
755     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
756         unchecked {
757             uint256 result = log2(value);
758             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
759         }
760     }
761 
762     /**
763      * @dev Return the log in base 10, rounded down, of a positive value.
764      * Returns 0 if given 0.
765      */
766     function log10(uint256 value) internal pure returns (uint256) {
767         uint256 result = 0;
768         unchecked {
769             if (value >= 10**64) {
770                 value /= 10**64;
771                 result += 64;
772             }
773             if (value >= 10**32) {
774                 value /= 10**32;
775                 result += 32;
776             }
777             if (value >= 10**16) {
778                 value /= 10**16;
779                 result += 16;
780             }
781             if (value >= 10**8) {
782                 value /= 10**8;
783                 result += 8;
784             }
785             if (value >= 10**4) {
786                 value /= 10**4;
787                 result += 4;
788             }
789             if (value >= 10**2) {
790                 value /= 10**2;
791                 result += 2;
792             }
793             if (value >= 10**1) {
794                 result += 1;
795             }
796         }
797         return result;
798     }
799 
800     /**
801      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
802      * Returns 0 if given 0.
803      */
804     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
805         unchecked {
806             uint256 result = log10(value);
807             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
808         }
809     }
810 
811     /**
812      * @dev Return the log in base 256, rounded down, of a positive value.
813      * Returns 0 if given 0.
814      *
815      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
816      */
817     function log256(uint256 value) internal pure returns (uint256) {
818         uint256 result = 0;
819         unchecked {
820             if (value >> 128 > 0) {
821                 value >>= 128;
822                 result += 16;
823             }
824             if (value >> 64 > 0) {
825                 value >>= 64;
826                 result += 8;
827             }
828             if (value >> 32 > 0) {
829                 value >>= 32;
830                 result += 4;
831             }
832             if (value >> 16 > 0) {
833                 value >>= 16;
834                 result += 2;
835             }
836             if (value >> 8 > 0) {
837                 result += 1;
838             }
839         }
840         return result;
841     }
842 
843     /**
844      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
845      * Returns 0 if given 0.
846      */
847     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
848         unchecked {
849             uint256 result = log256(value);
850             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
851         }
852     }
853 }
854 
855 // File: @openzeppelin/contracts/utils/Strings.sol
856 
857 
858 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 /**
863  * @dev String operations.
864  */
865 library Strings {
866     bytes16 private constant _SYMBOLS = "0123456789abcdef";
867     uint8 private constant _ADDRESS_LENGTH = 20;
868 
869     /**
870      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
871      */
872     function toString(uint256 value) internal pure returns (string memory) {
873         unchecked {
874             uint256 length = Math.log10(value) + 1;
875             string memory buffer = new string(length);
876             uint256 ptr;
877             /// @solidity memory-safe-assembly
878             assembly {
879                 ptr := add(buffer, add(32, length))
880             }
881             while (true) {
882                 ptr--;
883                 /// @solidity memory-safe-assembly
884                 assembly {
885                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
886                 }
887                 value /= 10;
888                 if (value == 0) break;
889             }
890             return buffer;
891         }
892     }
893 
894     /**
895      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
896      */
897     function toHexString(uint256 value) internal pure returns (string memory) {
898         unchecked {
899             return toHexString(value, Math.log256(value) + 1);
900         }
901     }
902 
903     /**
904      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
905      */
906     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
907         bytes memory buffer = new bytes(2 * length + 2);
908         buffer[0] = "0";
909         buffer[1] = "x";
910         for (uint256 i = 2 * length + 1; i > 1; --i) {
911             buffer[i] = _SYMBOLS[value & 0xf];
912             value >>= 4;
913         }
914         require(value == 0, "Strings: hex length insufficient");
915         return string(buffer);
916     }
917 
918     /**
919      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
920      */
921     function toHexString(address addr) internal pure returns (string memory) {
922         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
923     }
924 }
925 
926 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 /**
934  * @dev Implementation of the {IERC165} interface.
935  *
936  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
937  * for the additional interface id that will be supported. For example:
938  *
939  * ```solidity
940  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
941  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
942  * }
943  * ```
944  *
945  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
946  */
947 abstract contract ERC165 is IERC165 {
948     /**
949      * @dev See {IERC165-supportsInterface}.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952         return interfaceId == type(IERC165).interfaceId;
953     }
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
957 
958 
959 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 
964 
965 
966 
967 
968 
969 /**
970  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
971  * the Metadata extension, but not including the Enumerable extension, which is available separately as
972  * {ERC721Enumerable}.
973  */
974 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
975     using Address for address;
976     using Strings for uint256;
977 
978     // Token name
979     string private _name;
980 
981     // Token symbol
982     string private _symbol;
983 
984     // Mapping from token ID to owner address
985     mapping(uint256 => address) private _owners;
986 
987     // Mapping owner address to token count
988     mapping(address => uint256) private _balances;
989 
990     // Mapping from token ID to approved address
991     mapping(uint256 => address) private _tokenApprovals;
992 
993     // Mapping from owner to operator approvals
994     mapping(address => mapping(address => bool)) private _operatorApprovals;
995 
996     /**
997      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
998      */
999     constructor(string memory name_, string memory symbol_) {
1000         _name = name_;
1001         _symbol = symbol_;
1002     }
1003 
1004     /**
1005      * @dev See {IERC165-supportsInterface}.
1006      */
1007     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1008         return
1009             interfaceId == type(IERC721).interfaceId ||
1010             interfaceId == type(IERC721Metadata).interfaceId ||
1011             super.supportsInterface(interfaceId);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-balanceOf}.
1016      */
1017     function balanceOf(address owner) public view virtual override returns (uint256) {
1018         require(owner != address(0), "ERC721: address zero is not a valid owner");
1019         return _balances[owner];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-ownerOf}.
1024      */
1025     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1026         address owner = _ownerOf(tokenId);
1027         require(owner != address(0), "ERC721: invalid token ID");
1028         return owner;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-name}.
1033      */
1034     function name() public view virtual override returns (string memory) {
1035         return _name;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Metadata-symbol}.
1040      */
1041     function symbol() public view virtual override returns (string memory) {
1042         return _symbol;
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Metadata-tokenURI}.
1047      */
1048     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1049         _requireMinted(tokenId);
1050 
1051         string memory baseURI = _baseURI();
1052         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1053     }
1054 
1055     /**
1056      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1057      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1058      * by default, can be overridden in child contracts.
1059      */
1060     function _baseURI() internal view virtual returns (string memory) {
1061         return "";
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-approve}.
1066      */
1067     function approve(address to, uint256 tokenId) public virtual override {
1068         address owner = ERC721.ownerOf(tokenId);
1069         require(to != owner, "ERC721: approval to current owner");
1070 
1071         require(
1072             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1073             "ERC721: approve caller is not token owner or approved for all"
1074         );
1075 
1076         _approve(to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-getApproved}.
1081      */
1082     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1083         _requireMinted(tokenId);
1084 
1085         return _tokenApprovals[tokenId];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-setApprovalForAll}.
1090      */
1091     function setApprovalForAll(address operator, bool approved) public virtual override {
1092         _setApprovalForAll(_msgSender(), operator, approved);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-isApprovedForAll}.
1097      */
1098     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1099         return _operatorApprovals[owner][operator];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-transferFrom}.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         //solhint-disable-next-line max-line-length
1111         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1112 
1113         _transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-safeTransferFrom}.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) public virtual override {
1124         safeTransferFrom(from, to, tokenId, "");
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-safeTransferFrom}.
1129      */
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory data
1135     ) public virtual override {
1136         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1137         _safeTransfer(from, to, tokenId, data);
1138     }
1139 
1140     /**
1141      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1142      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1143      *
1144      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1145      *
1146      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1147      * implement alternative mechanisms to perform token transfer, such as signature-based.
1148      *
1149      * Requirements:
1150      *
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must exist and be owned by `from`.
1154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _safeTransfer(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes memory data
1163     ) internal virtual {
1164         _transfer(from, to, tokenId);
1165         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1166     }
1167 
1168     /**
1169      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1170      */
1171     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1172         return _owners[tokenId];
1173     }
1174 
1175     /**
1176      * @dev Returns whether `tokenId` exists.
1177      *
1178      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1179      *
1180      * Tokens start existing when they are minted (`_mint`),
1181      * and stop existing when they are burned (`_burn`).
1182      */
1183     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1184         return _ownerOf(tokenId) != address(0);
1185     }
1186 
1187     /**
1188      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      */
1194     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1195         address owner = ERC721.ownerOf(tokenId);
1196         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1197     }
1198 
1199     /**
1200      * @dev Safely mints `tokenId` and transfers it to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must not exist.
1205      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _safeMint(address to, uint256 tokenId) internal virtual {
1210         _safeMint(to, tokenId, "");
1211     }
1212 
1213     /**
1214      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1215      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1216      */
1217     function _safeMint(
1218         address to,
1219         uint256 tokenId,
1220         bytes memory data
1221     ) internal virtual {
1222         _mint(to, tokenId);
1223         require(
1224             _checkOnERC721Received(address(0), to, tokenId, data),
1225             "ERC721: transfer to non ERC721Receiver implementer"
1226         );
1227     }
1228 
1229     /**
1230      * @dev Mints `tokenId` and transfers it to `to`.
1231      *
1232      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must not exist.
1237      * - `to` cannot be the zero address.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _mint(address to, uint256 tokenId) internal virtual {
1242         require(to != address(0), "ERC721: mint to the zero address");
1243         require(!_exists(tokenId), "ERC721: token already minted");
1244 
1245         _beforeTokenTransfer(address(0), to, tokenId, 1);
1246 
1247         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1248         require(!_exists(tokenId), "ERC721: token already minted");
1249 
1250         unchecked {
1251             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1252             // Given that tokens are minted one by one, it is impossible in practice that
1253             // this ever happens. Might change if we allow batch minting.
1254             // The ERC fails to describe this case.
1255             _balances[to] += 1;
1256         }
1257 
1258         _owners[tokenId] = to;
1259 
1260         emit Transfer(address(0), to, tokenId);
1261 
1262         _afterTokenTransfer(address(0), to, tokenId, 1);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      * This is an internal function that does not check if the sender is authorized to operate on the token.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _burn(uint256 tokenId) internal virtual {
1277         address owner = ERC721.ownerOf(tokenId);
1278 
1279         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1280 
1281         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1282         owner = ERC721.ownerOf(tokenId);
1283 
1284         // Clear approvals
1285         delete _tokenApprovals[tokenId];
1286 
1287         unchecked {
1288             // Cannot overflow, as that would require more tokens to be burned/transferred
1289             // out than the owner initially received through minting and transferring in.
1290             _balances[owner] -= 1;
1291         }
1292         delete _owners[tokenId];
1293 
1294         emit Transfer(owner, address(0), tokenId);
1295 
1296         _afterTokenTransfer(owner, address(0), tokenId, 1);
1297     }
1298 
1299     /**
1300      * @dev Transfers `tokenId` from `from` to `to`.
1301      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1302      *
1303      * Requirements:
1304      *
1305      * - `to` cannot be the zero address.
1306      * - `tokenId` token must be owned by `from`.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _transfer(
1311         address from,
1312         address to,
1313         uint256 tokenId
1314     ) internal virtual {
1315         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1316         require(to != address(0), "ERC721: transfer to the zero address");
1317 
1318         _beforeTokenTransfer(from, to, tokenId, 1);
1319 
1320         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1321         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1322 
1323         // Clear approvals from the previous owner
1324         delete _tokenApprovals[tokenId];
1325 
1326         unchecked {
1327             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1328             // `from`'s balance is the number of token held, which is at least one before the current
1329             // transfer.
1330             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1331             // all 2**256 token ids to be minted, which in practice is impossible.
1332             _balances[from] -= 1;
1333             _balances[to] += 1;
1334         }
1335         _owners[tokenId] = to;
1336 
1337         emit Transfer(from, to, tokenId);
1338 
1339         _afterTokenTransfer(from, to, tokenId, 1);
1340     }
1341 
1342     /**
1343      * @dev Approve `to` to operate on `tokenId`
1344      *
1345      * Emits an {Approval} event.
1346      */
1347     function _approve(address to, uint256 tokenId) internal virtual {
1348         _tokenApprovals[tokenId] = to;
1349         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev Approve `operator` to operate on all of `owner` tokens
1354      *
1355      * Emits an {ApprovalForAll} event.
1356      */
1357     function _setApprovalForAll(
1358         address owner,
1359         address operator,
1360         bool approved
1361     ) internal virtual {
1362         require(owner != operator, "ERC721: approve to caller");
1363         _operatorApprovals[owner][operator] = approved;
1364         emit ApprovalForAll(owner, operator, approved);
1365     }
1366 
1367     /**
1368      * @dev Reverts if the `tokenId` has not been minted yet.
1369      */
1370     function _requireMinted(uint256 tokenId) internal view virtual {
1371         require(_exists(tokenId), "ERC721: invalid token ID");
1372     }
1373 
1374     /**
1375      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1376      * The call is not executed if the target address is not a contract.
1377      *
1378      * @param from address representing the previous owner of the given token ID
1379      * @param to target address that will receive the tokens
1380      * @param tokenId uint256 ID of the token to be transferred
1381      * @param data bytes optional data to send along with the call
1382      * @return bool whether the call correctly returned the expected magic value
1383      */
1384     function _checkOnERC721Received(
1385         address from,
1386         address to,
1387         uint256 tokenId,
1388         bytes memory data
1389     ) private returns (bool) {
1390         if (to.isContract()) {
1391             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1392                 return retval == IERC721Receiver.onERC721Received.selector;
1393             } catch (bytes memory reason) {
1394                 if (reason.length == 0) {
1395                     revert("ERC721: transfer to non ERC721Receiver implementer");
1396                 } else {
1397                     /// @solidity memory-safe-assembly
1398                     assembly {
1399                         revert(add(32, reason), mload(reason))
1400                     }
1401                 }
1402             }
1403         } else {
1404             return true;
1405         }
1406     }
1407 
1408     /**
1409      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1410      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1411      *
1412      * Calling conditions:
1413      *
1414      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1415      * - When `from` is zero, the tokens will be minted for `to`.
1416      * - When `to` is zero, ``from``'s tokens will be burned.
1417      * - `from` and `to` are never both zero.
1418      * - `batchSize` is non-zero.
1419      *
1420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1421      */
1422     function _beforeTokenTransfer(
1423         address from,
1424         address to,
1425         uint256 firstTokenId,
1426         uint256 batchSize
1427     ) internal virtual {}
1428 
1429     /**
1430      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1431      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1432      *
1433      * Calling conditions:
1434      *
1435      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1436      * - When `from` is zero, the tokens were minted for `to`.
1437      * - When `to` is zero, ``from``'s tokens were burned.
1438      * - `from` and `to` are never both zero.
1439      * - `batchSize` is non-zero.
1440      *
1441      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1442      */
1443     function _afterTokenTransfer(
1444         address from,
1445         address to,
1446         uint256 firstTokenId,
1447         uint256 batchSize
1448     ) internal virtual {}
1449 
1450     /**
1451      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1452      *
1453      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1454      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1455      * that `ownerOf(tokenId)` is `a`.
1456      */
1457     // solhint-disable-next-line func-name-mixedcase
1458     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1459         _balances[account] += amount;
1460     }
1461 }
1462 
1463 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1464 
1465 
1466 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1467 
1468 pragma solidity ^0.8.0;
1469 
1470 /**
1471  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1472  * @dev See https://eips.ethereum.org/EIPS/eip-721
1473  */
1474 interface IERC721Enumerable is IERC721 {
1475     /**
1476      * @dev Returns the total amount of tokens stored by the contract.
1477      */
1478     function totalSupply() external view returns (uint256);
1479 
1480     /**
1481      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1482      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1483      */
1484     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1485 
1486     /**
1487      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1488      * Use along with {totalSupply} to enumerate all tokens.
1489      */
1490     function tokenByIndex(uint256 index) external view returns (uint256);
1491 }
1492 
1493 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1494 
1495 
1496 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1497 
1498 pragma solidity ^0.8.0;
1499 
1500 
1501 /**
1502  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1503  * enumerability of all the token ids in the contract as well as all token ids owned by each
1504  * account.
1505  */
1506 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1507     // Mapping from owner to list of owned token IDs
1508     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1509 
1510     // Mapping from token ID to index of the owner tokens list
1511     mapping(uint256 => uint256) private _ownedTokensIndex;
1512 
1513     // Array with all token ids, used for enumeration
1514     uint256[] private _allTokens;
1515 
1516     // Mapping from token id to position in the allTokens array
1517     mapping(uint256 => uint256) private _allTokensIndex;
1518 
1519     /**
1520      * @dev See {IERC165-supportsInterface}.
1521      */
1522     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1523         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1524     }
1525 
1526     /**
1527      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1528      */
1529     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1530         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1531         return _ownedTokens[owner][index];
1532     }
1533 
1534     /**
1535      * @dev See {IERC721Enumerable-totalSupply}.
1536      */
1537     function totalSupply() public view virtual override returns (uint256) {
1538         return _allTokens.length;
1539     }
1540 
1541     /**
1542      * @dev See {IERC721Enumerable-tokenByIndex}.
1543      */
1544     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1545         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1546         return _allTokens[index];
1547     }
1548 
1549     /**
1550      * @dev See {ERC721-_beforeTokenTransfer}.
1551      */
1552     function _beforeTokenTransfer(
1553         address from,
1554         address to,
1555         uint256 firstTokenId,
1556         uint256 batchSize
1557     ) internal virtual override {
1558         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1559 
1560         if (batchSize > 1) {
1561             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1562             revert("ERC721Enumerable: consecutive transfers not supported");
1563         }
1564 
1565         uint256 tokenId = firstTokenId;
1566 
1567         if (from == address(0)) {
1568             _addTokenToAllTokensEnumeration(tokenId);
1569         } else if (from != to) {
1570             _removeTokenFromOwnerEnumeration(from, tokenId);
1571         }
1572         if (to == address(0)) {
1573             _removeTokenFromAllTokensEnumeration(tokenId);
1574         } else if (to != from) {
1575             _addTokenToOwnerEnumeration(to, tokenId);
1576         }
1577     }
1578 
1579     /**
1580      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1581      * @param to address representing the new owner of the given token ID
1582      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1583      */
1584     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1585         uint256 length = ERC721.balanceOf(to);
1586         _ownedTokens[to][length] = tokenId;
1587         _ownedTokensIndex[tokenId] = length;
1588     }
1589 
1590     /**
1591      * @dev Private function to add a token to this extension's token tracking data structures.
1592      * @param tokenId uint256 ID of the token to be added to the tokens list
1593      */
1594     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1595         _allTokensIndex[tokenId] = _allTokens.length;
1596         _allTokens.push(tokenId);
1597     }
1598 
1599     /**
1600      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1601      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1602      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1603      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1604      * @param from address representing the previous owner of the given token ID
1605      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1606      */
1607     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1608         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1609         // then delete the last slot (swap and pop).
1610 
1611         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1612         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1613 
1614         // When the token to delete is the last token, the swap operation is unnecessary
1615         if (tokenIndex != lastTokenIndex) {
1616             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1617 
1618             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1619             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1620         }
1621 
1622         // This also deletes the contents at the last position of the array
1623         delete _ownedTokensIndex[tokenId];
1624         delete _ownedTokens[from][lastTokenIndex];
1625     }
1626 
1627     /**
1628      * @dev Private function to remove a token from this extension's token tracking data structures.
1629      * This has O(1) time complexity, but alters the order of the _allTokens array.
1630      * @param tokenId uint256 ID of the token to be removed from the tokens list
1631      */
1632     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1633         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1634         // then delete the last slot (swap and pop).
1635 
1636         uint256 lastTokenIndex = _allTokens.length - 1;
1637         uint256 tokenIndex = _allTokensIndex[tokenId];
1638 
1639         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1640         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1641         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1642         uint256 lastTokenId = _allTokens[lastTokenIndex];
1643 
1644         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1645         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1646 
1647         // This also deletes the contents at the last position of the array
1648         delete _allTokensIndex[tokenId];
1649         _allTokens.pop();
1650     }
1651 }
1652 
1653 // File: @openzeppelin/contracts/access/Ownable.sol
1654 
1655 
1656 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 /**
1661  * @dev Contract module which provides a basic access control mechanism, where
1662  * there is an account (an owner) that can be granted exclusive access to
1663  * specific functions.
1664  *
1665  * By default, the owner account will be the one that deploys the contract. This
1666  * can later be changed with {transferOwnership}.
1667  *
1668  * This module is used through inheritance. It will make available the modifier
1669  * `onlyOwner`, which can be applied to your functions to restrict their use to
1670  * the owner.
1671  */
1672 abstract contract Ownable is Context {
1673     address private _owner;
1674 
1675     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1676 
1677     /**
1678      * @dev Initializes the contract setting the deployer as the initial owner.
1679      */
1680     constructor() {
1681         _transferOwnership(_msgSender());
1682     }
1683 
1684     /**
1685      * @dev Throws if called by any account other than the owner.
1686      */
1687     modifier onlyOwner() {
1688         _checkOwner();
1689         _;
1690     }
1691 
1692     /**
1693      * @dev Returns the address of the current owner.
1694      */
1695     function owner() public view virtual returns (address) {
1696         return _owner;
1697     }
1698 
1699     /**
1700      * @dev Throws if the sender is not the owner.
1701      */
1702     function _checkOwner() internal view virtual {
1703         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1704     }
1705 
1706     /**
1707      * @dev Leaves the contract without owner. It will not be possible to call
1708      * `onlyOwner` functions anymore. Can only be called by the current owner.
1709      *
1710      * NOTE: Renouncing ownership will leave the contract without an owner,
1711      * thereby removing any functionality that is only available to the owner.
1712      */
1713     function renounceOwnership() public virtual onlyOwner {
1714         _transferOwnership(address(0));
1715     }
1716 
1717     /**
1718      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1719      * Can only be called by the current owner.
1720      */
1721     function transferOwnership(address newOwner) public virtual onlyOwner {
1722         require(newOwner != address(0), "Ownable: new owner is the zero address");
1723         _transferOwnership(newOwner);
1724     }
1725 
1726     /**
1727      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1728      * Internal function without access restriction.
1729      */
1730     function _transferOwnership(address newOwner) internal virtual {
1731         address oldOwner = _owner;
1732         _owner = newOwner;
1733         emit OwnershipTransferred(oldOwner, newOwner);
1734     }
1735 }
1736 
1737 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1738 
1739 
1740 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1741 
1742 pragma solidity ^0.8.0;
1743 
1744 // CAUTION
1745 // This version of SafeMath should only be used with Solidity 0.8 or later,
1746 // because it relies on the compiler's built in overflow checks.
1747 
1748 /**
1749  * @dev Wrappers over Solidity's arithmetic operations.
1750  *
1751  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1752  * now has built in overflow checking.
1753  */
1754 library SafeMath {
1755     /**
1756      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1757      *
1758      * _Available since v3.4._
1759      */
1760     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1761         unchecked {
1762             uint256 c = a + b;
1763             if (c < a) return (false, 0);
1764             return (true, c);
1765         }
1766     }
1767 
1768     /**
1769      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1770      *
1771      * _Available since v3.4._
1772      */
1773     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1774         unchecked {
1775             if (b > a) return (false, 0);
1776             return (true, a - b);
1777         }
1778     }
1779 
1780     /**
1781      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1782      *
1783      * _Available since v3.4._
1784      */
1785     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1786         unchecked {
1787             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1788             // benefit is lost if 'b' is also tested.
1789             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1790             if (a == 0) return (true, 0);
1791             uint256 c = a * b;
1792             if (c / a != b) return (false, 0);
1793             return (true, c);
1794         }
1795     }
1796 
1797     /**
1798      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1799      *
1800      * _Available since v3.4._
1801      */
1802     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1803         unchecked {
1804             if (b == 0) return (false, 0);
1805             return (true, a / b);
1806         }
1807     }
1808 
1809     /**
1810      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1811      *
1812      * _Available since v3.4._
1813      */
1814     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1815         unchecked {
1816             if (b == 0) return (false, 0);
1817             return (true, a % b);
1818         }
1819     }
1820 
1821     /**
1822      * @dev Returns the addition of two unsigned integers, reverting on
1823      * overflow.
1824      *
1825      * Counterpart to Solidity's `+` operator.
1826      *
1827      * Requirements:
1828      *
1829      * - Addition cannot overflow.
1830      */
1831     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1832         return a + b;
1833     }
1834 
1835     /**
1836      * @dev Returns the subtraction of two unsigned integers, reverting on
1837      * overflow (when the result is negative).
1838      *
1839      * Counterpart to Solidity's `-` operator.
1840      *
1841      * Requirements:
1842      *
1843      * - Subtraction cannot overflow.
1844      */
1845     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1846         return a - b;
1847     }
1848 
1849     /**
1850      * @dev Returns the multiplication of two unsigned integers, reverting on
1851      * overflow.
1852      *
1853      * Counterpart to Solidity's `*` operator.
1854      *
1855      * Requirements:
1856      *
1857      * - Multiplication cannot overflow.
1858      */
1859     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1860         return a * b;
1861     }
1862 
1863     /**
1864      * @dev Returns the integer division of two unsigned integers, reverting on
1865      * division by zero. The result is rounded towards zero.
1866      *
1867      * Counterpart to Solidity's `/` operator.
1868      *
1869      * Requirements:
1870      *
1871      * - The divisor cannot be zero.
1872      */
1873     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1874         return a / b;
1875     }
1876 
1877     /**
1878      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1879      * reverting when dividing by zero.
1880      *
1881      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1882      * opcode (which leaves remaining gas untouched) while Solidity uses an
1883      * invalid opcode to revert (consuming all remaining gas).
1884      *
1885      * Requirements:
1886      *
1887      * - The divisor cannot be zero.
1888      */
1889     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1890         return a % b;
1891     }
1892 
1893     /**
1894      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1895      * overflow (when the result is negative).
1896      *
1897      * CAUTION: This function is deprecated because it requires allocating memory for the error
1898      * message unnecessarily. For custom revert reasons use {trySub}.
1899      *
1900      * Counterpart to Solidity's `-` operator.
1901      *
1902      * Requirements:
1903      *
1904      * - Subtraction cannot overflow.
1905      */
1906     function sub(
1907         uint256 a,
1908         uint256 b,
1909         string memory errorMessage
1910     ) internal pure returns (uint256) {
1911         unchecked {
1912             require(b <= a, errorMessage);
1913             return a - b;
1914         }
1915     }
1916 
1917     /**
1918      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1919      * division by zero. The result is rounded towards zero.
1920      *
1921      * Counterpart to Solidity's `/` operator. Note: this function uses a
1922      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1923      * uses an invalid opcode to revert (consuming all remaining gas).
1924      *
1925      * Requirements:
1926      *
1927      * - The divisor cannot be zero.
1928      */
1929     function div(
1930         uint256 a,
1931         uint256 b,
1932         string memory errorMessage
1933     ) internal pure returns (uint256) {
1934         unchecked {
1935             require(b > 0, errorMessage);
1936             return a / b;
1937         }
1938     }
1939 
1940     /**
1941      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1942      * reverting with custom message when dividing by zero.
1943      *
1944      * CAUTION: This function is deprecated because it requires allocating memory for the error
1945      * message unnecessarily. For custom revert reasons use {tryMod}.
1946      *
1947      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1948      * opcode (which leaves remaining gas untouched) while Solidity uses an
1949      * invalid opcode to revert (consuming all remaining gas).
1950      *
1951      * Requirements:
1952      *
1953      * - The divisor cannot be zero.
1954      */
1955     function mod(
1956         uint256 a,
1957         uint256 b,
1958         string memory errorMessage
1959     ) internal pure returns (uint256) {
1960         unchecked {
1961             require(b > 0, errorMessage);
1962             return a % b;
1963         }
1964     }
1965 }
1966 
1967 // File: @openzeppelin/contracts/utils/Base64.sol
1968 
1969 
1970 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
1971 
1972 pragma solidity ^0.8.0;
1973 
1974 /**
1975  * @dev Provides a set of functions to operate with Base64 strings.
1976  *
1977  * _Available since v4.5._
1978  */
1979 library Base64 {
1980     /**
1981      * @dev Base64 Encoding/Decoding Table
1982      */
1983     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1984 
1985     /**
1986      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1987      */
1988     function encode(bytes memory data) internal pure returns (string memory) {
1989         /**
1990          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1991          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1992          */
1993         if (data.length == 0) return "";
1994 
1995         // Loads the table into memory
1996         string memory table = _TABLE;
1997 
1998         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1999         // and split into 4 numbers of 6 bits.
2000         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
2001         // - `data.length + 2`  -> Round up
2002         // - `/ 3`              -> Number of 3-bytes chunks
2003         // - `4 *`              -> 4 characters for each chunk
2004         string memory result = new string(4 * ((data.length + 2) / 3));
2005 
2006         /// @solidity memory-safe-assembly
2007         assembly {
2008             // Prepare the lookup table (skip the first "length" byte)
2009             let tablePtr := add(table, 1)
2010 
2011             // Prepare result pointer, jump over length
2012             let resultPtr := add(result, 32)
2013 
2014             // Run over the input, 3 bytes at a time
2015             for {
2016                 let dataPtr := data
2017                 let endPtr := add(data, mload(data))
2018             } lt(dataPtr, endPtr) {
2019 
2020             } {
2021                 // Advance 3 bytes
2022                 dataPtr := add(dataPtr, 3)
2023                 let input := mload(dataPtr)
2024 
2025                 // To write each character, shift the 3 bytes (18 bits) chunk
2026                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
2027                 // and apply logical AND with 0x3F which is the number of
2028                 // the previous character in the ASCII table prior to the Base64 Table
2029                 // The result is then added to the table to get the character to write,
2030                 // and finally write it in the result pointer but with a left shift
2031                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
2032 
2033                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2034                 resultPtr := add(resultPtr, 1) // Advance
2035 
2036                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2037                 resultPtr := add(resultPtr, 1) // Advance
2038 
2039                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
2040                 resultPtr := add(resultPtr, 1) // Advance
2041 
2042                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
2043                 resultPtr := add(resultPtr, 1) // Advance
2044             }
2045 
2046             // When data `bytes` is not exactly 3 bytes long
2047             // it is padded with `=` characters at the end
2048             switch mod(mload(data), 3)
2049             case 1 {
2050                 mstore8(sub(resultPtr, 1), 0x3d)
2051                 mstore8(sub(resultPtr, 2), 0x3d)
2052             }
2053             case 2 {
2054                 mstore8(sub(resultPtr, 1), 0x3d)
2055             }
2056         }
2057 
2058         return result;
2059     }
2060 }
2061 
2062 // File: contracts/ChaosRoadsRenderer.sol
2063 
2064 
2065 pragma solidity ^0.8.11;
2066 
2067 
2068 
2069 contract ChaosRoadsRenderer is Ownable {
2070     using SafeMath for uint256;
2071     using Base64 for bytes;
2072 
2073     struct Palette {
2074         string tone;
2075         string color1;
2076         string color2;
2077         string color3;
2078         string color4;
2079         string color5;
2080     }
2081 
2082     mapping(uint256 => Palette) public palettes;
2083     uint256 paletteCount;
2084     string[] rows = [
2085         "In the dance of chaos, thoughts will pry",
2086         "As consciousness and turmoil vie",
2087         "In the tempest's eye, we observe and sigh",
2088         "As chaos clashes with a conscious ally",
2089         "A balance sought, in the struggle nearby",
2090         "Consciousness seeks order, reaching for the sky",
2091         "Amidst distortion, clarity we try",
2092         "Chaos and consciousness defy",
2093         "Through audio waves, chaos swirls nearby",
2094         "Consciousness strives to clarify",
2095         "Through tangled webs, the harmony we spy",
2096         "In dissonance, a melody we espy",
2097         "A cryptic question asks us why",
2098         "Through the cacophony, a truth we pry",
2099         "Order confronts chaos, do or die",
2100         "Through the tangled fray, clarity draws nigh",
2101         "Order seeks the light amidst a wild tide"
2102     ];
2103     string[] entropyRows = [
2104         " levels deep, the answers lie",
2105         " layers of turmoil, we all descry",
2106         " steps ahead, the paths go awry",
2107         " battles fought, only choices survive",
2108         " shades of shadows subtly multiply",
2109         " realms collide, struggles amplify",
2110         " whispers echo through a lie"
2111     ];
2112     
2113     constructor() {
2114         string[6][40] memory newPalettes = [
2115             ["red bliss","211103","3D1308","7B0D1E","9F2042","F8E5EE"],
2116             ["sunset synth","0D0D0D","FD9600","AC05FF","FE7102","E100FF"],
2117             ["monster","7C8483","60B2E5","71A2B6","53F4FF","982649"],
2118             ["modern strike","000","E6E6EA","009FB7","FE4A49","FED766"],
2119             ["tropic life","FFFD98","23395B","B9E3C6","D81E5B","59C9A5"],
2120             ["eclectic harmony","393E41","F6F7EB","E94F37","FFFC31","5C415D"],
2121             ["omani dunes","020122","F2F3AE","FC9E4F","F4442E","EDD382"],
2122             ["serene waters","80ED99","22577A","C7F9CC","38A3A5","57CC99"],
2123             ["neon splash","0AFFED","525252","BADEFC","B5446E","9D44B5"],
2124             ["nature in riot","000","546D64","4FB286","3C896D","50FFB1"],
2125             ["mystic garden","9EE493","42273B","ABC8C0","DAF7DC","70566D"],
2126             ["starry reflection","7CA5B8","020887","A9DBB8","C6EBBE","38369A"],
2127             ["lovers","F0386B","F8C0C8","E2C290","6B2D5C","FF5376"],
2128             ["ethereal dream","C98686","FFF4EC","F2B880","E7CFBC","966B9D"],
2129             ["blue train","22304C","3C526D","5A7191","7890B5","95AED9"],
2130             ["hypermage","9FA29A","000","FFF","0173B8","E50413"],
2131             ["hotel budapest","3A2529","E39E93","93645D","B77363","F3BEA1"],
2132             ["everything illuminated","A3D6B8","445F0B","C2C072","739D43","F9D801"],
2133             ["isfahan","B3989D","394C81","E6E0EB","67B1DB","34D6E4"],
2134             ["the queen","F7EB40","16131A","D71D2D","116A32","8A4158"],
2135             ["great wave","E3C29A","454963","ADAFAF","EBD7C4","29345C"],
2136             ["sugar shack","856548","3B4A49","4A2912","CBC5B8","292016"],
2137             ["water village","D4D5D1","525654","2A2E2D","F7F5EB","81CBA3"],
2138             ["half life","000","FFF","1E2D2C","EA975A","FB7E14"],
2139             ["spirited away","702f30","B8B689","B4575B","C6BCA4","E3D9D5"],
2140             ["indian wedding","490E45","E3304D","FCBB45","1C6144","BDCD2E"],
2141             ["dreamscape","B676DB","FED4E7","F2B79F","EDC9FF","D8CC34"],
2142             ["yin yang","404040","BFBFBF","7F7F7F","000","FFF"],
2143             ["pepe","000","1A44f1","AF6648","FFF","67974C"],
2144             ["earth embrace","8C4A2F","D19760","E2CFA8","A67C52","F5E9D6"],
2145             ["buragh","2C3D5B","FCD364","BFD8CB","D55143","28A690"],
2146             ["crimson twilight","763B69","070907","DD1834","536280","8D0D31"],
2147             ["punks","648497","010001","545554","997D58","DAB17F"],
2148             ["heavencomputer","CACACB","010101","5F8DAD","FFFAEE","ABDEE2"],
2149             ["genesisleft","131212","1FC4C8","5E719C","F6EEB2","E79CA0"],
2150             ["paella","F55A1B","F9A60F","221E1E","F17B04","FDEC5E"],
2151             ["all time high","7D0302","510403","EDD8D7","CA0402","140101"],
2152             ["winterberry whispers","000","175B32","EFA19B","FFF","8D1414"],
2153             ["vivid pulse","256EFF","46237A","3DDC97","FCFCFC","FF495C"],
2154             ["dreamy totoro","F77EB8","F4C0D9","E8E1F3","D1E0B3","FFDDB8"]
2155         ];
2156 
2157         for (uint256 i = 0; i < newPalettes.length; ++i) {
2158             palettes[paletteCount] = Palette(
2159                 newPalettes[i][0],
2160                 newPalettes[i][1],
2161                 newPalettes[i][2],
2162                 newPalettes[i][3],
2163                 newPalettes[i][4],
2164                 newPalettes[i][5]
2165             );
2166             paletteCount++;
2167         }
2168     }
2169 
2170     function formatTraits(uint256[8] memory rands) public pure returns (string memory) {
2171         string memory glow = "No";
2172         string memory overflow = "Yes";
2173 
2174         if (rands[0] > 50) {
2175             glow = "Yes";
2176         }
2177 
2178         if (rands[1] > 20) {
2179             overflow = "No";
2180         }
2181 
2182         return string(abi.encodePacked(
2183             '" }, { "trait_type": "Glow", "value": "',
2184             glow,
2185             '" }, { "trait_type": "Overflow", "value": "',
2186             overflow
2187         ));
2188     }
2189 
2190     function formatUriFooter(string memory _imageURI, string memory _animURI, uint256[8] memory rands, uint256 setDay, uint256 entropy)  public view returns (string memory) {
2191         return string(abi.encodePacked(
2192             '" }, { "trait_type": "Entropy", "value": "',
2193             uint2str(entropy),
2194             '" }, { "trait_type": "Conscious Choice", "value": "',
2195             uint2str(setDay),
2196             '" }], "description": "',
2197             getPoem(rands,entropy),
2198             '", "image": "',
2199             _imageURI,
2200             '", "animation_url": "',
2201             _animURI,
2202             '"}'
2203             ));
2204     }
2205 
2206     function formatTokenURI(uint256 tokenId, uint256 rand, uint256 setDay, uint256 entropy) public view returns (string memory) {
2207         string memory _imageURI = svgToURI(getSVGforThumbnail(entropy,rand));
2208         string memory _animURI = animToURI(string(abi.encodePacked(
2209             getAnimHeader(),
2210             getSVGforAnimation(entropy,rand),
2211             getAnimFooter(entropy,rand)
2212         )));
2213         uint256[8] memory rands = randConvert(rand);
2214         uint256 colPick = rands[2].mod(40);
2215         string memory byteEncoded = Base64.encode(bytes(abi.encodePacked(
2216             '{"name": "Chaos Road #',
2217             uint2str(tokenId),
2218             '", "description": "Chaos or consciousness?", ',
2219             '"attributes":[{ "trait_type": "Tone", "value": "',
2220             palettes[colPick].tone,
2221             formatTraits(rands),
2222             formatUriFooter(_imageURI,_animURI,rands,setDay,entropy)
2223         )));
2224         return string(abi.encodePacked("data:application/json;base64,", byteEncoded));
2225     }
2226 
2227     function svgToURI(string memory svg) public pure returns (string memory) {
2228         return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
2229     }
2230 
2231     function animToURI(string memory anim) public pure returns (string memory) {
2232         return string(abi.encodePacked("data:text/html;base64,", Base64.encode(bytes(anim))));
2233     }
2234 
2235     function getPoem(uint256[8] memory rands,uint256 entropy) public view returns (string memory) {
2236         uint256 colPick = rands[2].mod(40);
2237         uint256 row1 = block.timestamp % rows.length;
2238         uint256 row2 = rands[0] % rows.length;
2239         uint256 row3 = block.number % entropyRows.length;
2240         
2241         return string(abi.encodePacked(
2242             rows[row1],
2243             ". ",
2244             rows[row2],
2245             ". ",
2246             uint2str(entropy),
2247             entropyRows[row3],
2248             ". Behold ",
2249             palettes[colPick].tone,
2250             " in the tokenURI."
2251         ));
2252     }
2253 
2254     function getSVGfilters(uint256[8] memory rands,uint256 entropy) public view returns (string memory) {
2255         uint256 distort_evolve = (entropy.mul(18)).div(10);
2256         uint256 colPick = rands[2].mod(40);
2257         return string(abi.encodePacked(
2258             "<filter id='g' filterUnits='userSpaceOnUse'><feGaussianBlur in='SourceGraphic' stdDeviation='2' result='x'/><feGaussianBlur in='SourceGraphic' stdDeviation='5' result='y'/><feGaussianBlur in='SourceGraphic' stdDeviation='10' result='z'/><feMerge><feMergeNode in='x'/><feMergeNode in='y'/><feMergeNode in='z'/></feMerge></filter><filter id='c'><feOffset in='SourceGraphic' dx='0' dy='",
2259             uint2str(rands[3]%7),
2260             "'/></filter><filter id='d'><feOffset in='SourceGraphic' dx='0' dy='",
2261             uint2str(rands[3]%3),
2262             "'/></filter><filter id='e'><feOffset in='SourceGraphic' dx='0' dy='",
2263             uint2str(rands[3]%5),
2264             "'/></filter><filter id='f'><feOffset in='SourceGraphic' dx='0' dy='",
2265             uint2str(rands[3]%4),
2266             "'/></filter><filter id='b'><feTurbulence numOctaves='1' baseFrequency='0.01'/><feDisplacementMap in='SourceGraphic' xChannelSelector='B' yChannelSelector='G' scale='",
2267             uint2str(distort_evolve + 40),
2268             "'/></filter><filter id='a'><feTurbulence numOctaves='4' baseFrequency='0.3'/><feDisplacementMap scale='14'/></filter><path d='M0 0h960v960H0z' fill='#",
2269             palettes[colPick].color1,
2270             "'/><path d='M4 350h100v70l30 2v35l110 2-2 210-220-2m652-239H430l-6-180 90 2v-40l10 2 2-300 90-30' style='filter:url(#a)'/><path d='m0 0h630v630h-630z' fill='none' stroke='#0d0d0d' stroke-width='70' id='o'/><g id='u'>"
2271         ));
2272     }
2273 
2274     function getSVGdefiner(uint256[8] memory rands) public pure returns (string memory) {
2275         return string(abi.encodePacked(
2276             "<g id='t' style='filter: url(#b)' fill='none' stroke-linecap='round' stroke-dasharray='",
2277             uint2str((rands[0]%15) * 10),
2278             " ",
2279             uint2str((rands[1]%15) * 10),
2280             "' transform='scale(1.",
2281             uint2str(rands[4]%5),
2282             " 1.",
2283             uint2str(rands[5]%5),
2284             ") skewX(",
2285             uint2str(rands[2]%7),
2286             ") skewY(",
2287             uint2str(rands[0]%4),
2288             ") rotate(",
2289             uint2str((rands[4]%12)*10),
2290             " 315 315)'><g style='filter: url(#b)' class='li'>"
2291         ));
2292     }
2293     
2294     function getSVGforThumbnail(uint256 entropy, uint256 rand) public view returns (string memory) {
2295         return string(abi.encodePacked(
2296             "<svg width='630' height='630' viewBox='0 0 630 630' xmlns='http://www.w3.org/2000/svg' style='width: 360px; height: 360px; overflow: hidden;'>",
2297             combineSVGelements(entropy, rand)
2298         ));
2299     }
2300 
2301     function getSVGforAnimation(uint256 entropy, uint256 rand) public view returns (string memory) {
2302         return string(abi.encodePacked(
2303             "<svg width='630' height='630' viewBox='0 0 630 630' xmlns='http://www.w3.org/2000/svg'",
2304             combineSVGelements(entropy, rand)
2305         ));
2306     }
2307     
2308     function combineSVGelements(uint256 entropy, uint256 rand) public view returns (string memory) {
2309         uint256[8] memory rands = randConvert(rand);
2310         uint256 rotate_evolve = entropy >> 1;
2311         string[3] memory glow_frame = glowFrame(rands);
2312         return string(abi.encodePacked(
2313             getSVGfilters(rands, entropy),
2314             glow_frame[0],
2315             getSVGdefiner(rands),
2316             getStrokes(rands,entropy),
2317             "</g></g></g><use href='#t'/>",
2318             glow_frame[1],
2319             "<use href='#t' x='-630' y='-630' transform='rotate(",
2320             uint2str(rotate_evolve),
2321             ")'/>",
2322             glow_frame[2],
2323             "</svg>"
2324         ));
2325     }
2326 
2327     function getStrokes(uint256[8] memory rands, uint256 entropy) public view returns (string memory) {
2328         uint256 colPick = rands[2].mod(40);
2329         uint256 width_extend = entropy.div(10) + 12;
2330         return string(abi.encodePacked(
2331             "<g stroke='#",
2332             palettes[colPick].color2,
2333             "' stroke-width='",
2334             uint2str((rands[6]%17) * 4 + width_extend),
2335             "' style='filter: url(#c)'><path d='M-125 434c71 58 140 90 229 75s311 5 355 34 163-28 182-58-139-67-209-61-239-23-165-45 369-58 349-101c-20-44-134-23-254-7s-240 43-309-4c-69-46-463-478-447-520C-378-294-9 71 90 110c102 43 188 54 183-19-5-72 33-156 89-75s83 186 168 120S968-98 1033-49'/></g><g stroke='#",
2336             palettes[colPick].color3,
2337             "' stroke-width='",
2338             uint2str((rands[5]%17) * 4 + width_extend),
2339             "' style='filter: url(#d)'><path d='M-399 487S-15-44 81 394c176 803 289-215 320-156 52 103 81 512 94 458 87-386 441-398 441-398'/><path d='M-140-61C-114 17-67 80 14 68c81-11 143-538 149-491s-41 538 31 534 91 5 83 42c-7 38 32 174-29 133s-73-167-133-128c-61 39-418 73-511 47M622-133C428-90 420-515 387-460c-34 55-120 653-62 612s110-78 98-29-126 122-34 96 1211 375 242-4C497 108 785-67 1080-216'/></g><g stroke='#",
2340             palettes[colPick].color4,
2341             "' stroke-width='",
2342             uint2str((rands[6]%13) * 4 + width_extend),
2343             "' style='filter: url(#e)'><path d='M149-51c-32-9-93 5-119 67C4 77-113 139-51 118 10 97 96 37 116 84s-61 73-4 106 67 97 88 102'/><path d='M495 487c-34-13-224 15-185-26s142-79 32-53-240 63-201 21 204 0 98-29-181 94-180 15c4-141-140-186-32-146s106 84 215 82 209-53 214 13'/><path d='M405 380c71 102-144 117 49 114 391-9 907-340 153-343-299-1-19 244-177 103-58-55-71-210-71-147s-9 210-38 168c-51-75-71-347-216-381'/><path d='M349 225c-235-69-163-67-88-79s170 5 148-51c-22-57-213-1110-122-198 4 40 59 148-15 162-50 10-4 76-73 14-986-894-46-139-77-148m-480 748c57-54 360-212 419-185s-49 147 98 77c164-78 274 63 182 15-46-24-166-142-119-77 298 414 242-166 753 62'/></g><g stroke='#",
2344             palettes[colPick].color5,
2345             "' stroke-width='",
2346             uint2str((rands[5]%13) * 4 + width_extend),
2347             "' style='filter: url(#f)'><path d='M-322-223c110 13 225 361 258 373S187 32 169 56s-106 79-65 77c40-1 138-57 102-9-63 84 62-11 56 66-7 84 144-2 152-21 13-29-175-133-155-128 51 13 100 45 146 46 563-8 152-344 152-344M208 322c21-23 27-31 47-23 43 17 5 30-27 31'/><path d='M207-68c-5 33 18 79 47 90 51-2 30 17 104 13m158-158C490-93 578-6 422 2c-39 2-48-19-46 16s-5 175-36 55M134 356c-5 33 84 112 115 111 84-2 101 72 175 68m203-196c61 145-77 146-74 207 6 79-115 147-146 27'/></g>"
2348         ));
2349     }
2350 
2351     function glowFrame(uint256[8] memory rands) public pure returns (string[3] memory) {
2352         string[3] memory glow_frame;
2353 
2354         if (rands[0] > 50) {
2355             glow_frame[0] = "<g style='filter: url(#g)'>";
2356             glow_frame[1] = "</g>";
2357         }
2358 
2359         if (rands[1] > 20) {
2360             glow_frame[2] = "<use href='#o'/>";
2361         }
2362         return glow_frame;
2363     }
2364 
2365     function getAnimHeader() public pure returns (string memory) {
2366         string memory animHeader = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0, viewport-fit=cover'><title>Chaos Roads</title><style>* {margin: 0; padding: 0; border: 0;} body{overflow:hidden;} #playArea{width:100%;height:100vh;display: flex;justify-content:center;align-items:center;cursor:pointer;position:relative;} .lighted {animation-name:light;animation-duration:0.2s;animation-iteration-count:infinite;} @keyframes light{0%{scale:1;}20%{scale:1.002;}40%{scale:1.004;}50%{scale:1.005;}60%{scale:1.004;}80%{scale:1.002;}100%{scale:1;}}</style></head><body><div id='playArea'>";
2367         return animHeader;
2368     }
2369 
2370     function getAnimFooter(uint256 entropy, uint256 rand) public view returns (string memory) {
2371         uint256[8] memory rands = randConvert(rand);
2372         return string(abi.encodePacked(
2373             "</div><script>function isSafari() {return /^((?!chrome|android).)*safari/i.test(navigator.userAgent);} function addStyleForSafari() {if (isSafari()) {const svgElement=document.querySelector('svg');svgElement.setAttribute('style', 'width: 360px; height: 360px; overflow: hidden;');}}addStyleForSafari();const redElements = document.querySelectorAll('.li');function redSVG(){redElements.forEach((el) => {el.classList.toggle('lighted');});}const audioContext = new AudioContext();let isPlaying = false;let activeOscillators = [];const cMajorScale = [261.63,293.66,329.63,349.23,392.00,440.00,493.88,523.25];document.getElementById('playArea').addEventListener('click', async function() {if (audioContext.state === 'suspended') {await audioContext.resume();}toggleSound();});function toggleSound() {if (!isPlaying){isPlaying=true;isLooping=true;loopMelody();redSVG();} else {isPlaying=false;isLooping=false;stopMelody();redSVG();}}function playNote(frequency, startTime, duration) {const gainNode = audioContext.createGain();const osc=['sine','square','triangle','sawtooth'];const oscillatorCount=",
2374             uint2str((entropy/7).add(1)),
2375             ";const detuneAmount=",
2376             uint2str(block.number.mod(9)),
2377             "*20*(1 / Math.sqrt(oscillatorCount));for (let i=0; i < oscillatorCount; i++) {const oscillator=audioContext.createOscillator();oscillator.type=osc[",
2378             uint2str(block.number.mod(4)),
2379             "];oscillator.frequency.value=frequency;oscillator.detune.value=(i - Math.floor(oscillatorCount/2))*detuneAmount;oscillator.connect(gainNode);oscillator.start(startTime);oscillator.stop(startTime + duration);activeOscillators.push(oscillator);oscillator.onended=() => {const index = activeOscillators.indexOf(oscillator);if (index > -1) {activeOscillators.splice(index,1);}};}const fadeInDuration=1;const fadeOutDuration=1;gainNode.gain.setValueAtTime(0,startTime);gainNode.gain.linearRampToValueAtTime(0.5,startTime+fadeInDuration);gainNode.gain.setValueAtTime(0.5,startTime+duration-fadeOutDuration);gainNode.gain.linearRampToValueAtTime(0, startTime + duration);gainNode.connect(audioContext.destination);}function loopMelody() {if (!isLooping) return;const startTime=audioContext.currentTime;let totalDuration=9;playMelody();setTimeout(loopMelody,totalDuration*1000);}function playMelody() {const startTime=audioContext.currentTime;const rand=[0.",
2380             uint2str(rands[0]%10),
2381             ",0.",
2382             uint2str(rands[1]%10),
2383             ",0.",
2384             uint2str(rands[2]%10),
2385             ",0.",
2386             uint2str(rands[3]%10),
2387             ",0.",
2388             uint2str(rands[4]%10),
2389             ",0.",
2390             uint2str(rands[5]%10),
2391             ",0.",
2392             uint2str(rands[6]%10),
2393             ",0.",
2394             uint2str(rands[7]%10),
2395             "];for (let i=0; i<4; i++){const noteIndex=Math.floor(rand[i]*(cMajorScale.length-1));const noteDuration=2+(rand[i+4]*0.5)%2;playNote(cMajorScale[noteIndex],startTime+(i*noteDuration),noteDuration);}}function stopMelody(){activeOscillators.forEach(oscillator => {oscillator.stop();});activeOscillators=[];}</script></body></html>"
2396         ))
2397         ;
2398     }
2399     function uint2str(uint256 value) internal pure returns (string memory) {
2400         if (value == 0) {
2401             return "0";
2402         }
2403         uint256 temp = value;
2404         uint256 digits;
2405         while (temp != 0) {
2406             digits++;
2407             temp /= 10;
2408         }
2409         bytes memory buffer = new bytes(digits);
2410         while (value != 0) {
2411             digits -= 1;
2412             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2413             value /= 10;
2414         }
2415         return string(buffer);
2416     }
2417 
2418     function randConvert(uint256 rand) public pure returns (uint256[8] memory){
2419         uint256[8] memory rands;
2420         for (uint256 i = 0; i < 8; ++i) {
2421             rands[i] = uint256(keccak256(abi.encodePacked(rand.add(i)))).mod(100);
2422         }
2423 
2424         return rands;
2425     }
2426 
2427 }
2428 
2429 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2430 
2431 
2432 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2433 
2434 pragma solidity ^0.8.0;
2435 
2436 /**
2437  * @dev These functions deal with verification of Merkle Tree proofs.
2438  *
2439  * The tree and the proofs can be generated using our
2440  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2441  * You will find a quickstart guide in the readme.
2442  *
2443  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2444  * hashing, or use a hash function other than keccak256 for hashing leaves.
2445  * This is because the concatenation of a sorted pair of internal nodes in
2446  * the merkle tree could be reinterpreted as a leaf value.
2447  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2448  * against this attack out of the box.
2449  */
2450 library MerkleProof {
2451     /**
2452      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2453      * defined by `root`. For this, a `proof` must be provided, containing
2454      * sibling hashes on the branch from the leaf to the root of the tree. Each
2455      * pair of leaves and each pair of pre-images are assumed to be sorted.
2456      */
2457     function verify(
2458         bytes32[] memory proof,
2459         bytes32 root,
2460         bytes32 leaf
2461     ) internal pure returns (bool) {
2462         return processProof(proof, leaf) == root;
2463     }
2464 
2465     /**
2466      * @dev Calldata version of {verify}
2467      *
2468      * _Available since v4.7._
2469      */
2470     function verifyCalldata(
2471         bytes32[] calldata proof,
2472         bytes32 root,
2473         bytes32 leaf
2474     ) internal pure returns (bool) {
2475         return processProofCalldata(proof, leaf) == root;
2476     }
2477 
2478     /**
2479      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2480      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2481      * hash matches the root of the tree. When processing the proof, the pairs
2482      * of leafs & pre-images are assumed to be sorted.
2483      *
2484      * _Available since v4.4._
2485      */
2486     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2487         bytes32 computedHash = leaf;
2488         for (uint256 i = 0; i < proof.length; i++) {
2489             computedHash = _hashPair(computedHash, proof[i]);
2490         }
2491         return computedHash;
2492     }
2493 
2494     /**
2495      * @dev Calldata version of {processProof}
2496      *
2497      * _Available since v4.7._
2498      */
2499     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2500         bytes32 computedHash = leaf;
2501         for (uint256 i = 0; i < proof.length; i++) {
2502             computedHash = _hashPair(computedHash, proof[i]);
2503         }
2504         return computedHash;
2505     }
2506 
2507     /**
2508      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2509      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2510      *
2511      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2512      *
2513      * _Available since v4.7._
2514      */
2515     function multiProofVerify(
2516         bytes32[] memory proof,
2517         bool[] memory proofFlags,
2518         bytes32 root,
2519         bytes32[] memory leaves
2520     ) internal pure returns (bool) {
2521         return processMultiProof(proof, proofFlags, leaves) == root;
2522     }
2523 
2524     /**
2525      * @dev Calldata version of {multiProofVerify}
2526      *
2527      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2528      *
2529      * _Available since v4.7._
2530      */
2531     function multiProofVerifyCalldata(
2532         bytes32[] calldata proof,
2533         bool[] calldata proofFlags,
2534         bytes32 root,
2535         bytes32[] memory leaves
2536     ) internal pure returns (bool) {
2537         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2538     }
2539 
2540     /**
2541      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2542      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2543      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2544      * respectively.
2545      *
2546      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2547      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2548      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2549      *
2550      * _Available since v4.7._
2551      */
2552     function processMultiProof(
2553         bytes32[] memory proof,
2554         bool[] memory proofFlags,
2555         bytes32[] memory leaves
2556     ) internal pure returns (bytes32 merkleRoot) {
2557         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2558         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2559         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2560         // the merkle tree.
2561         uint256 leavesLen = leaves.length;
2562         uint256 totalHashes = proofFlags.length;
2563 
2564         // Check proof validity.
2565         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2566 
2567         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2568         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2569         bytes32[] memory hashes = new bytes32[](totalHashes);
2570         uint256 leafPos = 0;
2571         uint256 hashPos = 0;
2572         uint256 proofPos = 0;
2573         // At each step, we compute the next hash using two values:
2574         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2575         //   get the next hash.
2576         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2577         //   `proof` array.
2578         for (uint256 i = 0; i < totalHashes; i++) {
2579             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2580             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2581             hashes[i] = _hashPair(a, b);
2582         }
2583 
2584         if (totalHashes > 0) {
2585             return hashes[totalHashes - 1];
2586         } else if (leavesLen > 0) {
2587             return leaves[0];
2588         } else {
2589             return proof[0];
2590         }
2591     }
2592 
2593     /**
2594      * @dev Calldata version of {processMultiProof}.
2595      *
2596      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2597      *
2598      * _Available since v4.7._
2599      */
2600     function processMultiProofCalldata(
2601         bytes32[] calldata proof,
2602         bool[] calldata proofFlags,
2603         bytes32[] memory leaves
2604     ) internal pure returns (bytes32 merkleRoot) {
2605         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2606         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2607         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2608         // the merkle tree.
2609         uint256 leavesLen = leaves.length;
2610         uint256 totalHashes = proofFlags.length;
2611 
2612         // Check proof validity.
2613         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2614 
2615         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2616         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2617         bytes32[] memory hashes = new bytes32[](totalHashes);
2618         uint256 leafPos = 0;
2619         uint256 hashPos = 0;
2620         uint256 proofPos = 0;
2621         // At each step, we compute the next hash using two values:
2622         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2623         //   get the next hash.
2624         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2625         //   `proof` array.
2626         for (uint256 i = 0; i < totalHashes; i++) {
2627             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2628             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2629             hashes[i] = _hashPair(a, b);
2630         }
2631 
2632         if (totalHashes > 0) {
2633             return hashes[totalHashes - 1];
2634         } else if (leavesLen > 0) {
2635             return leaves[0];
2636         } else {
2637             return proof[0];
2638         }
2639     }
2640 
2641     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2642         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2643     }
2644 
2645     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2646         /// @solidity memory-safe-assembly
2647         assembly {
2648             mstore(0x00, a)
2649             mstore(0x20, b)
2650             value := keccak256(0x00, 0x40)
2651         }
2652     }
2653 }
2654 
2655 // File: contracts/ChaosRoads.sol
2656 
2657 
2658 pragma solidity ^0.8.11;
2659 
2660 
2661 
2662 
2663 
2664 contract ChaosRoads is ERC721Enumerable, Ownable {
2665     using SafeMath for uint256;
2666     using SafeMath for uint64;
2667     using MerkleProof for bytes32[];
2668     ChaosRoadsRenderer public renderer;
2669 
2670     struct ChaosState {
2671         uint64 anchorTimestamp;
2672         uint64 setDay;
2673         uint128 rand;
2674     }
2675 
2676     uint256 tokenCounter;
2677     string statement;
2678     
2679     mapping(uint256 => ChaosState) public chaosStates;
2680 
2681     constructor(address _renderer) ERC721("Chaos Roads", "CHRO") {
2682         renderer = ChaosRoadsRenderer(_renderer);
2683     }
2684     // Add the constant and variables
2685     uint256 public constant MAX_TOTAL_SUPPLY = 400;
2686     uint64 public constant SECS_IN_DAY = 86400;
2687     uint256 public mint_price = 0.03 ether;
2688 
2689     /// allowlist allows addresses in allowlistedAddress to mint through allowlistMint()
2690     /// public-sale allows anyone to mint through publicMint()
2691     uint8 public allowlistTokensPerAddress = 1;
2692     uint8 public publicTokensPerAddress = 1;
2693     bool public allowlistSaleIsActive;
2694     bool public publicSaleIsActive;
2695 
2696     /// minted tokens per allowlisted address
2697     mapping(address => uint8) public allowlistedMints;
2698     mapping(address => uint8) public publicMints;
2699 
2700     // merkle root used to verify that a user is in the allowlist
2701     bytes32 allowlistMerkleRoot;
2702     bytes32 public merkleTx;
2703 
2704     function setMerkleTx(bytes32 _merkleTx) public onlyOwner
2705     {
2706         merkleTx = _merkleTx;
2707     }
2708     
2709     // ALL MODIFIERS
2710 
2711     // Token exists
2712     modifier tokenExists(uint256 _tokenId) {
2713         require(
2714             _exists(_tokenId),
2715             "URI query for nonexistent token"
2716         );
2717         _;
2718     }
2719 
2720     // Only token owner can call this function
2721     modifier onlyTokenOwner(uint256 _tokenId) {
2722         require(
2723             ownerOf(_tokenId) == msg.sender,
2724             "Caller is not the owner of the token"
2725         );
2726         _;
2727     }
2728 
2729     // The sale is active (allowlist)
2730     modifier activeAllowlistSale {
2731         require(allowlistSaleIsActive, "Allowlist sale not active");
2732         _;
2733     }
2734 
2735     // The sale is active (public)
2736     modifier activePublicSale {
2737         require(publicSaleIsActive, "Public sale not active");
2738         _;
2739     }
2740 
2741     // Mint price is paid
2742     modifier mintPricePaid(uint8 amount) {
2743         require(
2744             mint_price.mul(amount) <= msg.value,
2745             "Not enough ether to mint"
2746         );
2747         _;
2748     }
2749 
2750     // Address within the allowlist can mint maximum this much
2751     modifier amountWithinMaxAllowlist(uint8 amount) {
2752         require(
2753             allowlistedMints[msg.sender] + amount <= allowlistTokensPerAddress,
2754             "Not allowed to mint this much"
2755         );
2756         _;
2757     }
2758 
2759     // Address outside the allowlist can mint maximum this much
2760     modifier amountWithinMaxPublic(uint8 amount) {
2761         require(
2762             publicMints[msg.sender] + amount <= publicTokensPerAddress,
2763             "Not allowed to mint this much"
2764         );
2765         _;
2766     }
2767 
2768     // Max supply cannot be exceeded
2769     modifier amountWithinMaxSupply(uint8 amount) {
2770         require(
2771             tokenCounter.add(amount) <= MAX_TOTAL_SUPPLY,
2772             "Not enough tokens left to mint"
2773         );
2774         _;
2775     }
2776 
2777     // Address is in the allowlist merkletree
2778     modifier allowlisted(bytes32[] calldata proof) {
2779         require(
2780             isAddressAllowlisted(proof, msg.sender),
2781             "Address not allowlisted"
2782         );
2783         _;
2784     }
2785 
2786     /// set the amount of tokens allowlisted
2787     /// addresses are allowed to mint during pre-sale
2788     /// note: does not affect public sale
2789     function setMaxMintsPerAllowlistedAddress(uint8 tokensPerAddress) public onlyOwner
2790     {
2791         allowlistTokensPerAddress = tokensPerAddress;
2792     }
2793 
2794     function setMaxMintsPerPublicAddress(uint8 tokensPerAddress) public onlyOwner
2795     {
2796         publicTokensPerAddress = tokensPerAddress;
2797     }
2798 
2799     /// set merkle root for allowlist verification
2800     function setAllowlistMerkleRoot(bytes32 merkleRoot) public onlyOwner {
2801         allowlistMerkleRoot = merkleRoot;
2802     }
2803 
2804     /// set which sale(s) should be active or inactive
2805     function setAllowlistAndPublicSale(
2806         bool _allowlistSaleIsActive,
2807         bool _publicSaleIsActive
2808     ) public onlyOwner {
2809         allowlistSaleIsActive = _allowlistSaleIsActive;
2810         publicSaleIsActive = _publicSaleIsActive;
2811     }
2812 
2813     /// verify that an address is in the allowlist
2814     function isAddressAllowlisted(bytes32[] memory proof, address _address) internal view returns (bool)
2815     {
2816         return proof.verify(allowlistMerkleRoot, keccak256(abi.encodePacked(_address)));
2817     }
2818 
2819     /// Reserve mint: For me, and amazing devs/artists who helped me along the way
2820     function reserveMint(uint8 amount) public payable
2821         onlyOwner
2822         amountWithinMaxSupply(amount)
2823     {
2824         mint(amount);
2825     }
2826 
2827     /// Allowlist minting, for everyone who is on the allowlist
2828     function allowlistMint(uint8 amount, bytes32[] calldata proof) public payable
2829         activeAllowlistSale
2830         mintPricePaid(amount)
2831         allowlisted(proof)
2832         amountWithinMaxSupply(amount)
2833         amountWithinMaxAllowlist(amount)
2834     {
2835         allowlistedMints[msg.sender] += amount;
2836         mint(amount);
2837     }
2838 
2839     /// Public minting, might not even happen
2840     function publicMint(uint8 amount) public payable
2841         activePublicSale
2842         mintPricePaid(amount)
2843         amountWithinMaxSupply(amount)
2844         amountWithinMaxPublic(amount)
2845 
2846     {
2847         publicMints[msg.sender] += amount;
2848         mint(amount);
2849     }
2850 
2851     /// Ultimate mint function
2852     function mint(uint8 amount) private {
2853         unchecked {
2854             if (amount == 0) return ;
2855             uint256 i;
2856             do {
2857                 tokenCounter = tokenCounter.add(1);
2858                 chaosStates[tokenCounter].rand = randomize(tokenCounter);
2859                 chaosStates[tokenCounter].anchorTimestamp = uint64(block.timestamp);
2860                 _safeMint(msg.sender, tokenCounter);
2861             } while (++i < amount);
2862         }
2863     }
2864 
2865     /// Get the entropy progress of a specific token
2866     function getEntropy(uint256 tokenId) public view 
2867     tokenExists(tokenId)
2868     returns(uint256){
2869         uint256 chaosProgress = block.timestamp - chaosStates[tokenId].anchorTimestamp;
2870         uint256 entropy = (chaosProgress + (chaosStates[tokenId].setDay * SECS_IN_DAY))/SECS_IN_DAY;
2871         return min(365, entropy);
2872     }
2873 
2874     /// Reconstruct tokenURI where the art resides
2875     function tokenURI(uint256 tokenId) 
2876     public view override 
2877     tokenExists(tokenId)
2878     returns (string memory) {
2879         return renderer.formatTokenURI(tokenId, chaosStates[tokenId].rand, chaosStates[tokenId].setDay, getEntropy(tokenId));
2880     }
2881 
2882     /// Observe your art, and change its entropy
2883     function observe(uint256 _tokenId,uint64 _number) public onlyTokenOwner(_tokenId) {
2884         ChaosState memory _chaosState = chaosStates[_tokenId];
2885         require(
2886             _chaosState.anchorTimestamp.add(_number*SECS_IN_DAY) < block.timestamp, "This is a future date"
2887         );
2888         require(_number < 365, "Pick within 1 year");
2889         _chaosState.anchorTimestamp = uint64(block.timestamp);
2890         _chaosState.setDay = _number;
2891         chaosStates[_tokenId] = _chaosState;
2892     }
2893 
2894     /// Randomization
2895     function randomize(uint256 seed) internal view returns (uint128) {
2896         return uint128(uint256(keccak256(abi.encodePacked(seed, block.timestamp, msg.sender))));
2897     }
2898 
2899     /// Minimum
2900     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2901         return a < b ? a : b;
2902     }
2903 
2904     /// Withdraw funds from the contract
2905     function withdraw() public onlyOwner {
2906         uint256 balance = address(this).balance;
2907         require(balance > 0, "No balance to withdraw");
2908         payable(owner()).transfer(balance);
2909     }
2910 
2911 }