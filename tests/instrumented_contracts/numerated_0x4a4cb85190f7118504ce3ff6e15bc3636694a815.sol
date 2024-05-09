1 // File: @openzeppelin\contracts\utils\introspection\IERC165.sol
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
29 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
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
175 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
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
205 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
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
233 // File: @openzeppelin\contracts\utils\Address.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
237 
238 pragma solidity ^0.8.0;
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
480 // File: @openzeppelin\contracts\utils\Context.sol
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
507 // File: @openzeppelin\contracts\utils\math\Math.sol
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
677         // 鈫?`sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
678         // 鈫?`2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
679         //
680         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
681         uint256 result = 1 << (Log2(a) >> 1);
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
713     function Log2(uint256 value) internal pure returns (uint256) {
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
755     function Log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
756         unchecked {
757             uint256 result = Log2(value);
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
817     function Log256(uint256 value) internal pure returns (uint256) {
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
847     function Log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
848         unchecked {
849             uint256 result = Log256(value);
850             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
851         }
852     }
853 }
854 
855 // File: @openzeppelin\contracts\utils\Strings.sol
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
899             return toHexString(value, Math.Log256(value) + 1);
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
926 // File: @openzeppelin\contracts\utils\introspection\ERC165.sol
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
956 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
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
1460 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
1461 
1462 
1463 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 /**
1468  * @dev Interface of the ERC20 standard as defined in the EIP.
1469  */
1470 interface IERC20 {
1471     /**
1472      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1473      * another (`to`).
1474      *
1475      * Note that `value` may be zero.
1476      */
1477     event Transfer(address indexed from, address indexed to, uint256 value);
1478 
1479     /**
1480      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1481      * a call to {approve}. `value` is the new allowance.
1482      */
1483     event Approval(address indexed owner, address indexed spender, uint256 value);
1484 
1485     /**
1486      * @dev Returns the amount of tokens in existence.
1487      */
1488     function totalSupply() external view returns (uint256);
1489 
1490     /**
1491      * @dev Returns the amount of tokens owned by `account`.
1492      */
1493     function balanceOf(address account) external view returns (uint256);
1494 
1495     /**
1496      * @dev Moves `amount` tokens from the caller's account to `to`.
1497      *
1498      * Returns a boolean value indicating whether the operation succeeded.
1499      *
1500      * Emits a {Transfer} event.
1501      */
1502     function transfer(address to, uint256 amount) external returns (bool);
1503 
1504     /**
1505      * @dev Returns the remaining number of tokens that `spender` will be
1506      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1507      * zero by default.
1508      *
1509      * This value changes when {approve} or {transferFrom} are called.
1510      */
1511     function allowance(address owner, address spender) external view returns (uint256);
1512 
1513     /**
1514      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1515      *
1516      * Returns a boolean value indicating whether the operation succeeded.
1517      *
1518      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1519      * that someone may use both the old and the new allowance by unfortunate
1520      * transaction ordering. One possible solution to mitigate this race
1521      * condition is to first reduce the spender's allowance to 0 and set the
1522      * desired value afterwards:
1523      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1524      *
1525      * Emits an {Approval} event.
1526      */
1527     function approve(address spender, uint256 amount) external returns (bool);
1528 
1529     /**
1530      * @dev Moves `amount` tokens from `from` to `to` using the
1531      * allowance mechanism. `amount` is then deducted from the caller's
1532      * allowance.
1533      *
1534      * Returns a boolean value indicating whether the operation succeeded.
1535      *
1536      * Emits a {Transfer} event.
1537      */
1538     function transferFrom(
1539         address from,
1540         address to,
1541         uint256 amount
1542     ) external returns (bool);
1543 }
1544 
1545 // File: @openzeppelin\contracts\access\Ownable.sol
1546 
1547 
1548 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1549 
1550 pragma solidity ^0.8.0;
1551 
1552 /**
1553  * @dev Contract module which provides a basic access control mechanism, where
1554  * there is an account (an owner) that can be granted exclusive access to
1555  * specific functions.
1556  *
1557  * By default, the owner account will be the one that deploys the contract. This
1558  * can later be changed with {transferOwnership}.
1559  *
1560  * This module is used through inheritance. It will make available the modifier
1561  * `onlyOwner`, which can be applied to your functions to restrict their use to
1562  * the owner.
1563  */
1564 abstract contract Ownable is Context {
1565     address private _owner;
1566 
1567     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1568 
1569     /**
1570      * @dev Initializes the contract setting the deployer as the initial owner.
1571      */
1572     constructor() {
1573         _transferOwnership(_msgSender());
1574     }
1575 
1576     /**
1577      * @dev Throws if called by any account other than the owner.
1578      */
1579     modifier onlyOwner() {
1580         _checkOwner();
1581         _;
1582     }
1583 
1584     /**
1585      * @dev Returns the address of the current owner.
1586      */
1587     function owner() public view virtual returns (address) {
1588         return _owner;
1589     }
1590 
1591     /**
1592      * @dev Throws if the sender is not the owner.
1593      */
1594     function _checkOwner() internal view virtual {
1595         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1596     }
1597 
1598     /**
1599      * @dev Leaves the contract without owner. It will not be possible to call
1600      * `onlyOwner` functions anymore. Can only be called by the current owner.
1601      *
1602      * NOTE: Renouncing ownership will leave the contract without an owner,
1603      * thereby removing any functionality that is only available to the owner.
1604      */
1605     function renounceOwnership() public virtual onlyOwner {
1606         _transferOwnership(address(0));
1607     }
1608 
1609     /**
1610      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1611      * Can only be called by the current owner.
1612      */
1613     function transferOwnership(address newOwner) public virtual onlyOwner {
1614         require(newOwner != address(0), "Ownable: new owner is the zero address");
1615         _transferOwnership(newOwner);
1616     }
1617 
1618     /**
1619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1620      * Internal function without access restriction.
1621      */
1622     function _transferOwnership(address newOwner) internal virtual {
1623         address oldOwner = _owner;
1624         _owner = newOwner;
1625         emit OwnershipTransferred(oldOwner, newOwner);
1626     }
1627 }
1628 
1629 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1630 
1631 
1632 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 /**
1637  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1638  * @dev See https://eips.ethereum.org/EIPS/eip-721
1639  */
1640 interface IERC721Enumerable is IERC721 {
1641     /**
1642      * @dev Returns the total amount of tokens stored by the contract.
1643      */
1644     function totalSupply() external view returns (uint256);
1645 
1646     /**
1647      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1648      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1649      */
1650     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1651 
1652     /**
1653      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1654      * Use along with {totalSupply} to enumerate all tokens.
1655      */
1656     function tokenByIndex(uint256 index) external view returns (uint256);
1657 }
1658 
1659 // File: @openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1660 
1661 
1662 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1663 
1664 pragma solidity ^0.8.0;
1665 
1666 
1667 /**
1668  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1669  * enumerability of all the token ids in the contract as well as all token ids owned by each
1670  * account.
1671  */
1672 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1673     // Mapping from owner to list of owned token IDs
1674     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1675 
1676     // Mapping from token ID to index of the owner tokens list
1677     mapping(uint256 => uint256) private _ownedTokensIndex;
1678 
1679     // Array with all token ids, used for enumeration
1680     uint256[] private _allTokens;
1681 
1682     // Mapping from token id to position in the allTokens array
1683     mapping(uint256 => uint256) private _allTokensIndex;
1684 
1685     /**
1686      * @dev See {IERC165-supportsInterface}.
1687      */
1688     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1689         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1690     }
1691 
1692     /**
1693      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1694      */
1695     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1696         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1697         return _ownedTokens[owner][index];
1698     }
1699 
1700     /**
1701      * @dev See {IERC721Enumerable-totalSupply}.
1702      */
1703     function totalSupply() public view virtual override returns (uint256) {
1704         return _allTokens.length;
1705     }
1706 
1707     /**
1708      * @dev See {IERC721Enumerable-tokenByIndex}.
1709      */
1710     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1711         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1712         return _allTokens[index];
1713     }
1714 
1715     /**
1716      * @dev See {ERC721-_beforeTokenTransfer}.
1717      */
1718     function _beforeTokenTransfer(
1719         address from,
1720         address to,
1721         uint256 firstTokenId,
1722         uint256 batchSize
1723     ) internal virtual override {
1724         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1725 
1726         if (batchSize > 1) {
1727             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1728             revert("ERC721Enumerable: consecutive transfers not supported");
1729         }
1730 
1731         uint256 tokenId = firstTokenId;
1732 
1733         if (from == address(0)) {
1734             _addTokenToAllTokensEnumeration(tokenId);
1735         } else if (from != to) {
1736             _removeTokenFromOwnerEnumeration(from, tokenId);
1737         }
1738         if (to == address(0)) {
1739             _removeTokenFromAllTokensEnumeration(tokenId);
1740         } else if (to != from) {
1741             _addTokenToOwnerEnumeration(to, tokenId);
1742         }
1743     }
1744 
1745     /**
1746      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1747      * @param to address representing the new owner of the given token ID
1748      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1749      */
1750     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1751         uint256 length = ERC721.balanceOf(to);
1752         _ownedTokens[to][length] = tokenId;
1753         _ownedTokensIndex[tokenId] = length;
1754     }
1755 
1756     /**
1757      * @dev Private function to add a token to this extension's token tracking data structures.
1758      * @param tokenId uint256 ID of the token to be added to the tokens list
1759      */
1760     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1761         _allTokensIndex[tokenId] = _allTokens.length;
1762         _allTokens.push(tokenId);
1763     }
1764 
1765     /**
1766      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1767      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1768      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1769      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1770      * @param from address representing the previous owner of the given token ID
1771      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1772      */
1773     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1774         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1775         // then delete the last slot (swap and pop).
1776 
1777         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1778         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1779 
1780         // When the token to delete is the last token, the swap operation is unnecessary
1781         if (tokenIndex != lastTokenIndex) {
1782             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1783 
1784             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1785             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1786         }
1787 
1788         // This also deletes the contents at the last position of the array
1789         delete _ownedTokensIndex[tokenId];
1790         delete _ownedTokens[from][lastTokenIndex];
1791     }
1792 
1793     /**
1794      * @dev Private function to remove a token from this extension's token tracking data structures.
1795      * This has O(1) time complexity, but alters the order of the _allTokens array.
1796      * @param tokenId uint256 ID of the token to be removed from the tokens list
1797      */
1798     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1799         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1800         // then delete the last slot (swap and pop).
1801 
1802         uint256 lastTokenIndex = _allTokens.length - 1;
1803         uint256 tokenIndex = _allTokensIndex[tokenId];
1804 
1805         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1806         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1807         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1808         uint256 lastTokenId = _allTokens[lastTokenIndex];
1809 
1810         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1811         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1812 
1813         // This also deletes the contents at the last position of the array
1814         delete _allTokensIndex[tokenId];
1815         _allTokens.pop();
1816     }
1817 }
1818 
1819 // File: @openzeppelin\contracts\access\IAccessControl.sol
1820 
1821 
1822 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1823 
1824 pragma solidity ^0.8.0;
1825 
1826 /**
1827  * @dev External interface of AccessControl declared to support ERC165 detection.
1828  */
1829 interface IAccessControl {
1830     /**
1831      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1832      *
1833      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1834      * {RoleAdminChanged} not being emitted signaling this.
1835      *
1836      * _Available since v3.1._
1837      */
1838     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1839 
1840     /**
1841      * @dev Emitted when `account` is granted `role`.
1842      *
1843      * `sender` is the account that originated the contract call, an admin role
1844      * bearer except when using {AccessControl-_setupRole}.
1845      */
1846     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1847 
1848     /**
1849      * @dev Emitted when `account` is revoked `role`.
1850      *
1851      * `sender` is the account that originated the contract call:
1852      *   - if using `revokeRole`, it is the admin role bearer
1853      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1854      */
1855     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1856 
1857     /**
1858      * @dev Returns `true` if `account` has been granted `role`.
1859      */
1860     function hasRole(bytes32 role, address account) external view returns (bool);
1861 
1862     /**
1863      * @dev Returns the admin role that controls `role`. See {grantRole} and
1864      * {revokeRole}.
1865      *
1866      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1867      */
1868     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1869 
1870     /**
1871      * @dev Grants `role` to `account`.
1872      *
1873      * If `account` had not been already granted `role`, emits a {RoleGranted}
1874      * event.
1875      *
1876      * Requirements:
1877      *
1878      * - the caller must have ``role``'s admin role.
1879      */
1880     function grantRole(bytes32 role, address account) external;
1881 
1882     /**
1883      * @dev Revokes `role` from `account`.
1884      *
1885      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1886      *
1887      * Requirements:
1888      *
1889      * - the caller must have ``role``'s admin role.
1890      */
1891     function revokeRole(bytes32 role, address account) external;
1892 
1893     /**
1894      * @dev Revokes `role` from the calling account.
1895      *
1896      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1897      * purpose is to provide a mechanism for accounts to lose their privileges
1898      * if they are compromised (such as when a trusted device is misplaced).
1899      *
1900      * If the calling account had been granted `role`, emits a {RoleRevoked}
1901      * event.
1902      *
1903      * Requirements:
1904      *
1905      * - the caller must be `account`.
1906      */
1907     function renounceRole(bytes32 role, address account) external;
1908 }
1909 
1910 // File: @openzeppelin\contracts\access\AccessControl.sol
1911 
1912 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
1913 
1914 pragma solidity ^0.8.0;
1915 
1916 
1917 
1918 
1919 /**
1920  * @dev Contract module that allows children to implement role-based access
1921  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1922  * members except through off-chain means by accessing the contract event logs. Some
1923  * applications may benefit from on-chain enumerability, for those cases see
1924  * {AccessControlEnumerable}.
1925  *
1926  * Roles are referred to by their `bytes32` identifier. These should be exposed
1927  * in the external API and be unique. The best way to achieve this is by
1928  * using `public constant` hash digests:
1929  *
1930  * ```
1931  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1932  * ```
1933  *
1934  * Roles can be used to represent a set of permissions. To restrict access to a
1935  * function call, use {hasRole}:
1936  *
1937  * ```
1938  * function foo() public {
1939  *     require(hasRole(MY_ROLE, msg.sender));
1940  *     ...
1941  * }
1942  * ```
1943  *
1944  * Roles can be granted and revoked dynamically via the {grantRole} and
1945  * {revokeRole} functions. Each role has an associated admin role, and only
1946  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1947  *
1948  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1949  * that only accounts with this role will be able to grant or revoke other
1950  * roles. More complex role relationships can be created by using
1951  * {_setRoleAdmin}.
1952  *
1953  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1954  * grant and revoke this role. Extra precautions should be taken to secure
1955  * accounts that have been granted it.
1956  */
1957 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1958     struct RoleData {
1959         mapping(address => bool) members;
1960         bytes32 adminRole;
1961     }
1962 
1963     mapping(bytes32 => RoleData) private _roles;
1964 
1965     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1966 
1967     /**
1968      * @dev Modifier that checks that an account has a specific role. Reverts
1969      * with a standardized message including the required role.
1970      *
1971      * The format of the revert reason is given by the following regular expression:
1972      *
1973      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1974      *
1975      * _Available since v4.1._
1976      */
1977     modifier onlyRole(bytes32 role) {
1978         _checkRole(role);
1979         _;
1980     }
1981 
1982     /**
1983      * @dev See {IERC165-supportsInterface}.
1984      */
1985     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1986         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1987     }
1988 
1989     /**
1990      * @dev Returns `true` if `account` has been granted `role`.
1991      */
1992     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1993         return _roles[role].members[account];
1994     }
1995 
1996     /**
1997      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1998      * Overriding this function changes the behavior of the {onlyRole} modifier.
1999      *
2000      * Format of the revert message is described in {_checkRole}.
2001      *
2002      * _Available since v4.6._
2003      */
2004     function _checkRole(bytes32 role) internal view virtual {
2005         _checkRole(role, _msgSender());
2006     }
2007 
2008     /**
2009      * @dev Revert with a standard message if `account` is missing `role`.
2010      *
2011      * The format of the revert reason is given by the following regular expression:
2012      *
2013      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2014      */
2015     function _checkRole(bytes32 role, address account) internal view virtual {
2016         if (!hasRole(role, account)) {
2017             revert(
2018                 string(
2019                     abi.encodePacked(
2020                         "AccessControl: account ",
2021                         Strings.toHexString(account),
2022                         " is missing role ",
2023                         Strings.toHexString(uint256(role), 32)
2024                     )
2025                 )
2026             );
2027         }
2028     }
2029 
2030     /**
2031      * @dev Returns the admin role that controls `role`. See {grantRole} and
2032      * {revokeRole}.
2033      *
2034      * To change a role's admin, use {_setRoleAdmin}.
2035      */
2036     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2037         return _roles[role].adminRole;
2038     }
2039 
2040     /**
2041      * @dev Grants `role` to `account`.
2042      *
2043      * If `account` had not been already granted `role`, emits a {RoleGranted}
2044      * event.
2045      *
2046      * Requirements:
2047      *
2048      * - the caller must have ``role``'s admin role.
2049      *
2050      * May emit a {RoleGranted} event.
2051      */
2052     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2053         _grantRole(role, account);
2054     }
2055 
2056     /**
2057      * @dev Revokes `role` from `account`.
2058      *
2059      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2060      *
2061      * Requirements:
2062      *
2063      * - the caller must have ``role``'s admin role.
2064      *
2065      * May emit a {RoleRevoked} event.
2066      */
2067     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2068         _revokeRole(role, account);
2069     }
2070 
2071     /**
2072      * @dev Revokes `role` from the calling account.
2073      *
2074      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2075      * purpose is to provide a mechanism for accounts to lose their privileges
2076      * if they are compromised (such as when a trusted device is misplaced).
2077      *
2078      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2079      * event.
2080      *
2081      * Requirements:
2082      *
2083      * - the caller must be `account`.
2084      *
2085      * May emit a {RoleRevoked} event.
2086      */
2087     function renounceRole(bytes32 role, address account) public virtual override {
2088         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2089 
2090         _revokeRole(role, account);
2091     }
2092 
2093     /**
2094      * @dev Grants `role` to `account`.
2095      *
2096      * If `account` had not been already granted `role`, emits a {RoleGranted}
2097      * event. Note that unlike {grantRole}, this function doesn't perform any
2098      * checks on the calling account.
2099      *
2100      * May emit a {RoleGranted} event.
2101      *
2102      * [WARNING]
2103      * ====
2104      * This function should only be called from the constructor when setting
2105      * up the initial roles for the system.
2106      *
2107      * Using this function in any other way is effectively circumventing the admin
2108      * system imposed by {AccessControl}.
2109      * ====
2110      *
2111      * NOTE: This function is deprecated in favor of {_grantRole}.
2112      */
2113     function _setupRole(bytes32 role, address account) internal virtual {
2114         _grantRole(role, account);
2115     }
2116 
2117     /**
2118      * @dev Sets `adminRole` as ``role``'s admin role.
2119      *
2120      * Emits a {RoleAdminChanged} event.
2121      */
2122     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2123         bytes32 previousAdminRole = getRoleAdmin(role);
2124         _roles[role].adminRole = adminRole;
2125         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2126     }
2127 
2128     /**
2129      * @dev Grants `role` to `account`.
2130      *
2131      * Internal function without access restriction.
2132      *
2133      * May emit a {RoleGranted} event.
2134      */
2135     function _grantRole(bytes32 role, address account) internal virtual {
2136         if (!hasRole(role, account)) {
2137             _roles[role].members[account] = true;
2138             emit RoleGranted(role, account, _msgSender());
2139         }
2140     }
2141 
2142     /**
2143      * @dev Revokes `role` from `account`.
2144      *
2145      * Internal function without access restriction.
2146      *
2147      * May emit a {RoleRevoked} event.
2148      */
2149     function _revokeRole(bytes32 role, address account) internal virtual {
2150         if (hasRole(role, account)) {
2151             _roles[role].members[account] = false;
2152             emit RoleRevoked(role, account, _msgSender());
2153         }
2154     }
2155 }
2156 
2157 // File: contracts\GameNFTEth.sol
2158 
2159 
2160 
2161 pragma solidity ^0.8.0;
2162 contract GameNFTEth is ERC721, ERC721Enumerable, Ownable, AccessControl {
2163     string public PROVENANCE="Ethereum";
2164     address public MASTER;
2165     bytes32 public constant MASTER_ROLE = keccak256('MASTER_ROLE');
2166     bytes32 public constant ADMIN_ROLE = keccak256('ADMIN_ROLE');
2167   
2168     bool public saleIsActive = true;
2169     string private _baseURIextended;
2170      // Mapping from token ID to auth id
2171     mapping(uint256 => uint256) public _tokenAuths;
2172     // Mapping from sign to use
2173     mapping(uint256 => bool) authIdUsed;
2174 
2175 
2176 
2177     constructor(string memory _name, string memory _symbol, string memory baseuri, address masterAddress, address[] memory admins) ERC721(_name, _symbol) {
2178         MASTER = masterAddress;
2179         _baseURIextended = baseuri;
2180         _setupRole(MASTER_ROLE, MASTER);
2181         _setupRole(MASTER_ROLE, admins[0]);
2182         _setupRole(ADMIN_ROLE, MASTER);
2183         _setRoleAdmin(ADMIN_ROLE, MASTER_ROLE);
2184         for(uint i = 0; i < admins.length; i ++){
2185             grantRole(ADMIN_ROLE, admins[i]);
2186         }
2187     }
2188 
2189     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
2190         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2191     }
2192 
2193     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable,AccessControl) returns (bool) {
2194         return super.supportsInterface(interfaceId);
2195     }
2196 
2197     function setBaseURI(string memory baseURI_) external onlyRole(ADMIN_ROLE) {
2198         _baseURIextended = baseURI_;
2199     }
2200 
2201     function _baseURI() internal view virtual override returns (string memory) {
2202         return _baseURIextended;
2203     }
2204 
2205     function setProvenance(string memory provenance) public onlyRole(MASTER_ROLE) {
2206         PROVENANCE = provenance;
2207     }
2208 
2209     function setSaleState(bool newState) public onlyRole(ADMIN_ROLE) {
2210         saleIsActive = newState;
2211     }
2212 
2213     function mintSerials(uint256 startauthid, uint256 num) public onlyRole(ADMIN_ROLE) {
2214         for(uint i = 0; i < num; ++i ){
2215             mint(MASTER, startauthid + i);
2216         }
2217     }
2218     function mint(address to, uint256 authId) internal {
2219          uint256 tokenId = totalSupply() + 1;
2220         _safeMint(to, tokenId);
2221         _tokenAuths[tokenId] = authId;
2222         authIdUsed[authId] = true;
2223     }
2224     function ethBuy(address to, uint256[] memory authIds, uint256 totalprice, uint256 deadline, bytes memory _signature) public payable {
2225         require(saleIsActive, "Sale must be active to mint tokens");
2226         require(msg.value >= totalprice, "Insufficient price");
2227         require(verify(to, authIds, totalprice, deadline, abi.encodePacked(address(this)), _signature), "invalid signature ");
2228         require(deadline <= 0 || deadline >= block.timestamp, "Signature has expired");
2229         require(totalSupply() + authIds.length <= 500 , "Superior limit");
2230         for(uint i = 0; i < authIds.length; i ++){
2231             require(!authIdUsed[authIds[i]], "Authid used");
2232         }
2233         for(uint i = 0; i < authIds.length; i ++){
2234             mint(to, authIds[i]);  
2235         } 
2236     }
2237     function withdraw() public onlyRole(ADMIN_ROLE) {
2238         uint balance = address(this).balance;
2239         payable(MASTER).transfer(balance);
2240     }
2241      function withdrawToken(uint256 _amount, IERC20 token) public onlyRole(ADMIN_ROLE) {
2242         token.transfer(MASTER, _amount);
2243     }
2244     function isAdmin(address user) public view returns(bool) {
2245         return hasRole(ADMIN_ROLE, user);
2246     }
2247     function getAuthId(uint256 tokenId) public view returns(uint256) {
2248         return _tokenAuths[tokenId];
2249     }
2250     function getAuthIds(uint256[] memory tokenIds) public view returns(uint256[] memory) {
2251         uint256[] memory authids = new uint256[](tokenIds.length);
2252         for(uint i = 0; i < tokenIds.length; i ++){
2253             authids[i] = getAuthId(tokenIds[i]);
2254         }
2255         return authids;
2256     }
2257     function authHasUsed(uint256 authid) public view returns(bool){
2258         return authIdUsed[authid];
2259     }
2260     function getAllNfts(address user) public view returns(uint256[] memory) {
2261         uint256 length = ERC721.balanceOf(user);
2262         uint256[] memory tokenIds = new uint256[](length);
2263         for(uint256 i = 0; i < length; i++) {
2264             tokenIds[i] = (tokenOfOwnerByIndex(user,i));
2265         }
2266         return tokenIds;
2267     } 
2268     function getMessageHash(address _to, uint256[] memory authIds, uint256 price,uint256 deadline, bytes memory token) internal pure returns (bytes32) {
2269         return keccak256(abi.encodePacked(authIds, _to, price, deadline, token));
2270     }
2271     function verify(address _to, uint256[] memory authIds, uint256 price, uint256 deadline, bytes memory token, bytes memory signature) internal view returns (bool) {
2272         bytes32 messageHash = getMessageHash(_to, authIds, price, deadline, token);
2273         return hasRole(ADMIN_ROLE, recoverSigner(getEthSignedMessageHash(messageHash), signature));
2274     }
2275     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
2276         internal
2277         pure
2278         returns (address)
2279     {
2280         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
2281 
2282         return ecrecover(_ethSignedMessageHash, v, r, s);
2283     }
2284 
2285     function splitSignature(bytes memory sig)
2286         internal
2287         pure
2288         returns (
2289             bytes32 r,
2290             bytes32 s,
2291             uint8 v
2292         )
2293     {
2294         require(sig.length == 65, "invalid signature length");
2295 
2296         assembly {
2297             /*
2298             First 32 bytes stores the length of the signature
2299             add(sig, 32) = pointer of sig + 32
2300             effectively, skips first 32 bytes of signature
2301             mload(p) loads next 32 bytes starting at the memory address p into memory
2302             */
2303             // first 32 bytes, after the length prefix
2304             r := mload(add(sig, 32))
2305             // second 32 bytes
2306             s := mload(add(sig, 64))
2307             // final byte (first byte of the next 32 bytes)
2308             v := byte(0, mload(add(sig, 96)))
2309         }
2310         // implicitly return (r, s, v)
2311     }
2312     
2313 
2314     function getEthSignedMessageHash(bytes32 _messageHash)
2315         internal view
2316         returns (bytes32)
2317     {
2318         /*
2319         Signature is produced by signing a keccak256 hash with the following format:
2320         "\x19Ethereum Signed Message\n" + len(msg) + msg
2321         */
2322         return
2323             keccak256(
2324                 abi.encodePacked("\x19", PROVENANCE, " Signed Message:\n32", _messageHash)
2325             );
2326     }
2327 }