1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
3 
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
959 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
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
1425         uint256, /* firstTokenId */
1426         uint256 batchSize
1427     ) internal virtual {
1428         if (batchSize > 1) {
1429             if (from != address(0)) {
1430                 _balances[from] -= batchSize;
1431             }
1432             if (to != address(0)) {
1433                 _balances[to] += batchSize;
1434             }
1435         }
1436     }
1437 
1438     /**
1439      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1440      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1441      *
1442      * Calling conditions:
1443      *
1444      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1445      * - When `from` is zero, the tokens were minted for `to`.
1446      * - When `to` is zero, ``from``'s tokens were burned.
1447      * - `from` and `to` are never both zero.
1448      * - `batchSize` is non-zero.
1449      *
1450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1451      */
1452     function _afterTokenTransfer(
1453         address from,
1454         address to,
1455         uint256 firstTokenId,
1456         uint256 batchSize
1457     ) internal virtual {}
1458 }
1459 
1460 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1461 
1462 
1463 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 /**
1468  * @dev ERC721 token with storage based token URI management.
1469  */
1470 abstract contract ERC721URIStorage is ERC721 {
1471     using Strings for uint256;
1472 
1473     // Optional mapping for token URIs
1474     mapping(uint256 => string) private _tokenURIs;
1475 
1476     /**
1477      * @dev See {IERC721Metadata-tokenURI}.
1478      */
1479     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1480         _requireMinted(tokenId);
1481 
1482         string memory _tokenURI = _tokenURIs[tokenId];
1483         string memory base = _baseURI();
1484 
1485         // If there is no base URI, return the token URI.
1486         if (bytes(base).length == 0) {
1487             return _tokenURI;
1488         }
1489         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1490         if (bytes(_tokenURI).length > 0) {
1491             return string(abi.encodePacked(base, _tokenURI));
1492         }
1493 
1494         return super.tokenURI(tokenId);
1495     }
1496 
1497     /**
1498      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1499      *
1500      * Requirements:
1501      *
1502      * - `tokenId` must exist.
1503      */
1504     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1505         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1506         _tokenURIs[tokenId] = _tokenURI;
1507     }
1508 
1509     /**
1510      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1511      * token-specific URI was set for the token, and if so, it deletes the token URI from
1512      * the storage mapping.
1513      */
1514     function _burn(uint256 tokenId) internal virtual override {
1515         super._burn(tokenId);
1516 
1517         if (bytes(_tokenURIs[tokenId]).length != 0) {
1518             delete _tokenURIs[tokenId];
1519         }
1520     }
1521 }
1522 
1523 // File: @openzeppelin/contracts/access/Ownable.sol
1524 
1525 
1526 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1527 
1528 pragma solidity ^0.8.0;
1529 
1530 /**
1531  * @dev Contract module which provides a basic access control mechanism, where
1532  * there is an account (an owner) that can be granted exclusive access to
1533  * specific functions.
1534  *
1535  * By default, the owner account will be the one that deploys the contract. This
1536  * can later be changed with {transferOwnership}.
1537  *
1538  * This module is used through inheritance. It will make available the modifier
1539  * `onlyOwner`, which can be applied to your functions to restrict their use to
1540  * the owner.
1541  */
1542 abstract contract Ownable is Context {
1543     address private _owner;
1544 
1545     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1546 
1547     /**
1548      * @dev Initializes the contract setting the deployer as the initial owner.
1549      */
1550     constructor() {
1551         _transferOwnership(_msgSender());
1552     }
1553 
1554     /**
1555      * @dev Throws if called by any account other than the owner.
1556      */
1557     modifier onlyOwner() {
1558         _checkOwner();
1559         _;
1560     }
1561 
1562     /**
1563      * @dev Returns the address of the current owner.
1564      */
1565     function owner() public view virtual returns (address) {
1566         return _owner;
1567     }
1568 
1569     /**
1570      * @dev Throws if the sender is not the owner.
1571      */
1572     function _checkOwner() internal view virtual {
1573         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1574     }
1575 
1576     /**
1577      * @dev Leaves the contract without owner. It will not be possible to call
1578      * `onlyOwner` functions anymore. Can only be called by the current owner.
1579      *
1580      * NOTE: Renouncing ownership will leave the contract without an owner,
1581      * thereby removing any functionality that is only available to the owner.
1582      */
1583     function renounceOwnership() public virtual onlyOwner {
1584         _transferOwnership(address(0));
1585     }
1586 
1587     /**
1588      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1589      * Can only be called by the current owner.
1590      */
1591     function transferOwnership(address newOwner) public virtual onlyOwner {
1592         require(newOwner != address(0), "Ownable: new owner is the zero address");
1593         _transferOwnership(newOwner);
1594     }
1595 
1596     /**
1597      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1598      * Internal function without access restriction.
1599      */
1600     function _transferOwnership(address newOwner) internal virtual {
1601         address oldOwner = _owner;
1602         _owner = newOwner;
1603         emit OwnershipTransferred(oldOwner, newOwner);
1604     }
1605 }
1606 
1607 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1608 
1609 
1610 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1611 
1612 pragma solidity ^0.8.0;
1613 
1614 /**
1615  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1616  *
1617  * These functions can be used to verify that a message was signed by the holder
1618  * of the private keys of a given address.
1619  */
1620 library ECDSA {
1621     enum RecoverError {
1622         NoError,
1623         InvalidSignature,
1624         InvalidSignatureLength,
1625         InvalidSignatureS,
1626         InvalidSignatureV // Deprecated in v4.8
1627     }
1628 
1629     function _throwError(RecoverError error) private pure {
1630         if (error == RecoverError.NoError) {
1631             return; // no error: do nothing
1632         } else if (error == RecoverError.InvalidSignature) {
1633             revert("ECDSA: invalid signature");
1634         } else if (error == RecoverError.InvalidSignatureLength) {
1635             revert("ECDSA: invalid signature length");
1636         } else if (error == RecoverError.InvalidSignatureS) {
1637             revert("ECDSA: invalid signature 's' value");
1638         }
1639     }
1640 
1641     /**
1642      * @dev Returns the address that signed a hashed message (`hash`) with
1643      * `signature` or error string. This address can then be used for verification purposes.
1644      *
1645      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1646      * this function rejects them by requiring the `s` value to be in the lower
1647      * half order, and the `v` value to be either 27 or 28.
1648      *
1649      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1650      * verification to be secure: it is possible to craft signatures that
1651      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1652      * this is by receiving a hash of the original message (which may otherwise
1653      * be too long), and then calling {toEthSignedMessageHash} on it.
1654      *
1655      * Documentation for signature generation:
1656      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1657      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1658      *
1659      * _Available since v4.3._
1660      */
1661     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1662         if (signature.length == 65) {
1663             bytes32 r;
1664             bytes32 s;
1665             uint8 v;
1666             // ecrecover takes the signature parameters, and the only way to get them
1667             // currently is to use assembly.
1668             /// @solidity memory-safe-assembly
1669             assembly {
1670                 r := mload(add(signature, 0x20))
1671                 s := mload(add(signature, 0x40))
1672                 v := byte(0, mload(add(signature, 0x60)))
1673             }
1674             return tryRecover(hash, v, r, s);
1675         } else {
1676             return (address(0), RecoverError.InvalidSignatureLength);
1677         }
1678     }
1679 
1680     /**
1681      * @dev Returns the address that signed a hashed message (`hash`) with
1682      * `signature`. This address can then be used for verification purposes.
1683      *
1684      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1685      * this function rejects them by requiring the `s` value to be in the lower
1686      * half order, and the `v` value to be either 27 or 28.
1687      *
1688      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1689      * verification to be secure: it is possible to craft signatures that
1690      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1691      * this is by receiving a hash of the original message (which may otherwise
1692      * be too long), and then calling {toEthSignedMessageHash} on it.
1693      */
1694     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1695         (address recovered, RecoverError error) = tryRecover(hash, signature);
1696         _throwError(error);
1697         return recovered;
1698     }
1699 
1700     /**
1701      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1702      *
1703      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1704      *
1705      * _Available since v4.3._
1706      */
1707     function tryRecover(
1708         bytes32 hash,
1709         bytes32 r,
1710         bytes32 vs
1711     ) internal pure returns (address, RecoverError) {
1712         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1713         uint8 v = uint8((uint256(vs) >> 255) + 27);
1714         return tryRecover(hash, v, r, s);
1715     }
1716 
1717     /**
1718      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1719      *
1720      * _Available since v4.2._
1721      */
1722     function recover(
1723         bytes32 hash,
1724         bytes32 r,
1725         bytes32 vs
1726     ) internal pure returns (address) {
1727         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1728         _throwError(error);
1729         return recovered;
1730     }
1731 
1732     /**
1733      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1734      * `r` and `s` signature fields separately.
1735      *
1736      * _Available since v4.3._
1737      */
1738     function tryRecover(
1739         bytes32 hash,
1740         uint8 v,
1741         bytes32 r,
1742         bytes32 s
1743     ) internal pure returns (address, RecoverError) {
1744         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1745         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1746         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1747         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1748         //
1749         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1750         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1751         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1752         // these malleable signatures as well.
1753         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1754             return (address(0), RecoverError.InvalidSignatureS);
1755         }
1756 
1757         // If the signature is valid (and not malleable), return the signer address
1758         address signer = ecrecover(hash, v, r, s);
1759         if (signer == address(0)) {
1760             return (address(0), RecoverError.InvalidSignature);
1761         }
1762 
1763         return (signer, RecoverError.NoError);
1764     }
1765 
1766     /**
1767      * @dev Overload of {ECDSA-recover} that receives the `v`,
1768      * `r` and `s` signature fields separately.
1769      */
1770     function recover(
1771         bytes32 hash,
1772         uint8 v,
1773         bytes32 r,
1774         bytes32 s
1775     ) internal pure returns (address) {
1776         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1777         _throwError(error);
1778         return recovered;
1779     }
1780 
1781     /**
1782      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1783      * produces hash corresponding to the one signed with the
1784      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1785      * JSON-RPC method as part of EIP-191.
1786      *
1787      * See {recover}.
1788      */
1789     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1790         // 32 is the length in bytes of hash,
1791         // enforced by the type signature above
1792         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1793     }
1794 
1795     /**
1796      * @dev Returns an Ethereum Signed Message, created from `s`. This
1797      * produces hash corresponding to the one signed with the
1798      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1799      * JSON-RPC method as part of EIP-191.
1800      *
1801      * See {recover}.
1802      */
1803     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1804         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1805     }
1806 
1807     /**
1808      * @dev Returns an Ethereum Signed Typed Data, created from a
1809      * `domainSeparator` and a `structHash`. This produces hash corresponding
1810      * to the one signed with the
1811      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1812      * JSON-RPC method as part of EIP-712.
1813      *
1814      * See {recover}.
1815      */
1816     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1817         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1818     }
1819 }
1820 
1821 // File: @openzeppelin/contracts/utils/Counters.sol
1822 
1823 
1824 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1825 
1826 pragma solidity ^0.8.0;
1827 
1828 /**
1829  * @title Counters
1830  * @author Matt Condon (@shrugs)
1831  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1832  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1833  *
1834  * Include with `using Counters for Counters.Counter;`
1835  */
1836 library Counters {
1837     struct Counter {
1838         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1839         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1840         // this feature: see https://github.com/ethereum/solidity/issues/4637
1841         uint256 _value; // default: 0
1842     }
1843 
1844     function current(Counter storage counter) internal view returns (uint256) {
1845         return counter._value;
1846     }
1847 
1848     function increment(Counter storage counter) internal {
1849         unchecked {
1850             counter._value += 1;
1851         }
1852     }
1853 
1854     function decrement(Counter storage counter) internal {
1855         uint256 value = counter._value;
1856         require(value > 0, "Counter: decrement overflow");
1857         unchecked {
1858             counter._value = value - 1;
1859         }
1860     }
1861 
1862     function reset(Counter storage counter) internal {
1863         counter._value = 0;
1864     }
1865 }
1866 
1867 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
1868 
1869 
1870 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1871 
1872 pragma solidity ^0.8.0;
1873 
1874 /**
1875  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1876  *
1877  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1878  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1879  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1880  *
1881  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1882  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1883  * ({_hashTypedDataV4}).
1884  *
1885  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1886  * the chain id to protect against replay attacks on an eventual fork of the chain.
1887  *
1888  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1889  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1890  *
1891  * _Available since v3.4._
1892  */
1893 abstract contract EIP712 {
1894     /* solhint-disable var-name-mixedcase */
1895     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1896     // invalidate the cached domain separator if the chain id changes.
1897     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1898     uint256 private immutable _CACHED_CHAIN_ID;
1899     address private immutable _CACHED_THIS;
1900 
1901     bytes32 private immutable _HASHED_NAME;
1902     bytes32 private immutable _HASHED_VERSION;
1903     bytes32 private immutable _TYPE_HASH;
1904 
1905     /* solhint-enable var-name-mixedcase */
1906 
1907     /**
1908      * @dev Initializes the domain separator and parameter caches.
1909      *
1910      * The meaning of `name` and `version` is specified in
1911      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1912      *
1913      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1914      * - `version`: the current major version of the signing domain.
1915      *
1916      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1917      * contract upgrade].
1918      */
1919     constructor(string memory name, string memory version) {
1920         bytes32 hashedName = keccak256(bytes(name));
1921         bytes32 hashedVersion = keccak256(bytes(version));
1922         bytes32 typeHash = keccak256(
1923             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1924         );
1925         _HASHED_NAME = hashedName;
1926         _HASHED_VERSION = hashedVersion;
1927         _CACHED_CHAIN_ID = block.chainid;
1928         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1929         _CACHED_THIS = address(this);
1930         _TYPE_HASH = typeHash;
1931     }
1932 
1933     /**
1934      * @dev Returns the domain separator for the current chain.
1935      */
1936     function _domainSeparatorV4() internal view returns (bytes32) {
1937         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1938             return _CACHED_DOMAIN_SEPARATOR;
1939         } else {
1940             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1941         }
1942     }
1943 
1944     function _buildDomainSeparator(
1945         bytes32 typeHash,
1946         bytes32 nameHash,
1947         bytes32 versionHash
1948     ) private view returns (bytes32) {
1949         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1950     }
1951 
1952     /**
1953      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1954      * function returns the hash of the fully encoded EIP712 message for this domain.
1955      *
1956      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1957      *
1958      * ```solidity
1959      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1960      *     keccak256("Mail(address to,string contents)"),
1961      *     mailTo,
1962      *     keccak256(bytes(mailContents))
1963      * )));
1964      * address signer = ECDSA.recover(digest, signature);
1965      * ```
1966      */
1967     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1968         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1969     }
1970 }
1971 
1972 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1973 
1974 
1975 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/draft-EIP712.sol)
1976 
1977 pragma solidity ^0.8.0;
1978 
1979 // EIP-712 is Final as of 2022-08-11. This file is deprecated.
1980 
1981 // File: contract.sol
1982 
1983 
1984 pragma solidity ^0.8.11;
1985 
1986 
1987 
1988 
1989 
1990 
1991 contract NinetiesKids is ERC721URIStorage, Ownable, EIP712 {
1992   using ECDSA for bytes32;
1993 
1994   using Counters for Counters.Counter;
1995 
1996   uint256 private maxBurnSupply = 200;
1997 
1998   uint256 private maxLimitedSupply = 20;
1999 
2000   string private _baseTokenURI;
2001 
2002   string private _limitedEditionTokenURI;
2003 
2004   address private _systemAddress;
2005 
2006   mapping(string => bool) private _usedNonces;
2007 
2008   mapping(bytes32 => bool) private _redeemedLimitedEditionAddresses;
2009 
2010   mapping(bytes32 => bool) private _redeemedBurnAddresses;
2011 
2012   uint32 private currentLimitedEditionMappingVersion;
2013 
2014   uint32 private currentBurnedMappingVersion;
2015 
2016   Counters.Counter private _tokenIdCounter;
2017 
2018   Counters.Counter private _currentBaseUriCounter;
2019 
2020   Counters.Counter private _currentLimitedEditionUriCounter;
2021 
2022   constructor(address systemAddress) ERC721("90's Kids Club", "90SKIDSCLUB") EIP712("90's Kids Club", "90SKIDSCLUB") {
2023     _systemAddress =  systemAddress;
2024   }
2025 
2026   function publicMint(
2027     uint256 amount,
2028     string memory nonce,
2029     bytes32 hash,
2030     bytes memory signature
2031   ) external payable {
2032     bytes32 key = keccak256(abi.encodePacked(currentBurnedMappingVersion, msg.sender));
2033     require(matchSigner(hash, signature), "Mint must be done from 90skidsclub.xyz");
2034     require(bytes(_baseTokenURI).length > 0, "base uri is not set");
2035     require(_currentBaseUriCounter.current() < maxBurnSupply, "Max tokens distributed");
2036     require(!_redeemedBurnAddresses[key], "Already redeemed");
2037     require(!_usedNonces[nonce], "Hash reused");
2038     require(
2039       hashTransaction(msg.sender, amount, nonce) == hash,
2040       "Hash failed"
2041     );
2042 
2043     _usedNonces[nonce] = true;
2044 
2045     for (uint256 i = 1; i <= amount; i++) {
2046       _safeMint(msg.sender, _tokenIdCounter.current());
2047       _setTokenURI(_tokenIdCounter.current(), append(_baseTokenURI, _currentBaseUriCounter.current()));
2048       _redeemedBurnAddresses[key] = true;
2049       _tokenIdCounter.increment();
2050       _currentBaseUriCounter.increment();
2051     }
2052   }
2053 
2054   function publicLimitedEditionMint(
2055     uint256 amount,
2056     string memory nonce,
2057     bytes32 hash,
2058     bytes memory signature
2059   ) external payable {
2060     bytes32 key = keccak256(abi.encodePacked(currentLimitedEditionMappingVersion, msg.sender));
2061     require(matchSigner(hash, signature), "Mint must be done from 90skidsclub.xyz");
2062     require(bytes(_limitedEditionTokenURI).length > 0, "limited edition uri is not set");
2063     require(!_redeemedLimitedEditionAddresses[key], "Already redeemed");
2064     require(!_usedNonces[nonce], "Hash reused");
2065     require(_currentLimitedEditionUriCounter.current() < maxLimitedSupply, "Max tokens distributed");
2066     require(
2067       hashTransaction(msg.sender, amount, nonce) == hash,
2068       "Hash failed"
2069     );
2070 
2071     _usedNonces[nonce] = true;
2072 
2073     for (uint256 i = 1; i <= amount; i++) {
2074       _safeMint(msg.sender, _tokenIdCounter.current());
2075       _setTokenURI(_tokenIdCounter.current(), append(_limitedEditionTokenURI, _currentLimitedEditionUriCounter.current()));
2076       _redeemedLimitedEditionAddresses[key] = true;
2077       _tokenIdCounter.increment();
2078       _currentLimitedEditionUriCounter.increment();
2079     }
2080   }
2081 
2082   function mint(address receiver, string memory tokenURI) external payable onlyOwner {
2083       _safeMint(receiver, _tokenIdCounter.current());
2084       _setTokenURI(_tokenIdCounter.current(), tokenURI);
2085       _tokenIdCounter.increment();
2086   }
2087 
2088   function append(string memory a, uint256 b) internal pure returns (string memory) {
2089     return string(abi.encodePacked(a, Strings.toString(b)));
2090  }
2091 
2092   function matchSigner(bytes32 hash, bytes memory signature) public view returns (bool) {
2093     return _systemAddress == hash.toEthSignedMessageHash().recover(signature);
2094   }
2095 
2096   function hashTransaction(
2097     address sender,
2098     uint256 amount,
2099     string memory nonce
2100   ) public view returns (bytes32) {
2101 
2102     bytes32 hash = keccak256(
2103       abi.encodePacked(sender, amount, nonce, address(this))
2104     );
2105 
2106     return hash;
2107   }
2108 
2109   function withdrawAll(address payable to) external onlyOwner {
2110     to.transfer(address(this).balance);
2111   }
2112 
2113   function totalSupply() public view returns (uint) {
2114     return _tokenIdCounter.current();
2115   }
2116 
2117   function setMaxBurnSupply(uint256 max) external onlyOwner {
2118     maxBurnSupply = max;
2119   }
2120 
2121   function getMaxBurnSupply() public view returns (uint256) {
2122     return maxBurnSupply;
2123   }
2124 
2125   function setLimitedBurnSupply(uint256 max) external onlyOwner {
2126     maxLimitedSupply = max;
2127   }
2128 
2129   function getMaxLimitedSupply() public view returns (uint256) {
2130     return maxLimitedSupply;
2131   }
2132 
2133   // Set a new base uri and reset the counter to 0 for the new IPFS hash
2134   function setBaseUri(string memory uri) external onlyOwner {
2135     _baseTokenURI = uri;
2136     _currentBaseUriCounter.reset();
2137     currentBurnedMappingVersion++;
2138   }
2139 
2140   function baseUri() public view returns (string memory) {
2141     return _baseTokenURI;
2142   }
2143 
2144   // Set a limited edition base uri and reset the counter to 0 for the new IPFS hash
2145   function setLimitedEditionTokenURI(string memory uri) external onlyOwner {
2146     _limitedEditionTokenURI = uri;
2147     _currentLimitedEditionUriCounter.reset();
2148     currentLimitedEditionMappingVersion++;
2149   }
2150 
2151   function limitedEditionTokenURI() public view returns (string memory) {
2152     return _limitedEditionTokenURI;
2153   }
2154 
2155   function redeemedLimitedEdition(address wallet) public view returns (bool) {
2156         bytes32 key = keccak256(abi.encodePacked(currentLimitedEditionMappingVersion, wallet));
2157         return _redeemedLimitedEditionAddresses[key];
2158   }
2159 
2160   function redeemedBurned(address wallet) public view returns (bool) {
2161         bytes32 key = keccak256(abi.encodePacked(currentBurnedMappingVersion, wallet));
2162         return _redeemedBurnAddresses[key];
2163   }
2164 }