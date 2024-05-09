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
31 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId,
85         bytes calldata data
86     ) external;
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
112      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
113      * understand this adds an external call which potentially creates a reentrancy vulnerability.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 // File: @openzeppelin/contracts/utils/Address.sol
231 
232 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
233 
234 pragma solidity ^0.8.1;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      *
257      * [IMPORTANT]
258      * ====
259      * You shouldn't rely on `isContract` to protect against flash loan attacks!
260      *
261      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
262      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
263      * constructor.
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies on extcodesize/address.code.length, which returns 0
268         // for contracts in construction, since the code is only stored at the end
269         // of the constructor execution.
270 
271         return account.code.length > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
421      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
422      *
423      * _Available since v4.8._
424      */
425     function verifyCallResultFromTarget(
426         address target,
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         if (success) {
432             if (returndata.length == 0) {
433                 // only check isContract if the call was successful and the return data is empty
434                 // otherwise we already know that it was a contract
435                 require(isContract(target), "Address: call to non-contract");
436             }
437             return returndata;
438         } else {
439             _revert(returndata, errorMessage);
440         }
441     }
442 
443     /**
444      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
445      * revert reason or using the provided one.
446      *
447      * _Available since v4.3._
448      */
449     function verifyCallResult(
450         bool success,
451         bytes memory returndata,
452         string memory errorMessage
453     ) internal pure returns (bytes memory) {
454         if (success) {
455             return returndata;
456         } else {
457             _revert(returndata, errorMessage);
458         }
459     }
460 
461     function _revert(bytes memory returndata, string memory errorMessage) private pure {
462         // Look for revert reason and bubble it up if present
463         if (returndata.length > 0) {
464             // The easiest way to bubble the revert reason is using memory via assembly
465             /// @solidity memory-safe-assembly
466             assembly {
467                 let returndata_size := mload(returndata)
468                 revert(add(32, returndata), returndata_size)
469             }
470         } else {
471             revert(errorMessage);
472         }
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Context.sol
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Provides information about the current execution context, including the
484  * sender of the transaction and its data. While these are generally available
485  * via msg.sender and msg.data, they should not be accessed in such a direct
486  * manner, since when dealing with meta-transactions the account sending and
487  * paying for execution may not be the actual sender (as far as an application
488  * is concerned).
489  *
490  * This contract is only required for intermediate, library-like contracts.
491  */
492 abstract contract Context {
493     function _msgSender() internal view virtual returns (address) {
494         return msg.sender;
495     }
496 
497     function _msgData() internal view virtual returns (bytes calldata) {
498         return msg.data;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/utils/math/Math.sol
503 
504 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Standard math utilities missing in the Solidity language.
510  */
511 library Math {
512     enum Rounding {
513         Down, // Toward negative infinity
514         Up, // Toward infinity
515         Zero // Toward zero
516     }
517 
518     /**
519      * @dev Returns the largest of two numbers.
520      */
521     function max(uint256 a, uint256 b) internal pure returns (uint256) {
522         return a > b ? a : b;
523     }
524 
525     /**
526      * @dev Returns the smallest of two numbers.
527      */
528     function min(uint256 a, uint256 b) internal pure returns (uint256) {
529         return a < b ? a : b;
530     }
531 
532     /**
533      * @dev Returns the average of two numbers. The result is rounded towards
534      * zero.
535      */
536     function average(uint256 a, uint256 b) internal pure returns (uint256) {
537         // (a + b) / 2 can overflow.
538         return (a & b) + (a ^ b) / 2;
539     }
540 
541     /**
542      * @dev Returns the ceiling of the division of two numbers.
543      *
544      * This differs from standard division with `/` in that it rounds up instead
545      * of rounding down.
546      */
547     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
548         // (a + b - 1) / b can overflow on addition, so we distribute.
549         return a == 0 ? 0 : (a - 1) / b + 1;
550     }
551 
552     /**
553      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
554      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
555      * with further edits by Uniswap Labs also under MIT license.
556      */
557     function mulDiv(
558         uint256 x,
559         uint256 y,
560         uint256 denominator
561     ) internal pure returns (uint256 result) {
562         unchecked {
563             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
564             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
565             // variables such that product = prod1 * 2^256 + prod0.
566             uint256 prod0; // Least significant 256 bits of the product
567             uint256 prod1; // Most significant 256 bits of the product
568             assembly {
569                 let mm := mulmod(x, y, not(0))
570                 prod0 := mul(x, y)
571                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
572             }
573 
574             // Handle non-overflow cases, 256 by 256 division.
575             if (prod1 == 0) {
576                 return prod0 / denominator;
577             }
578 
579             // Make sure the result is less than 2^256. Also prevents denominator == 0.
580             require(denominator > prod1);
581 
582             ///////////////////////////////////////////////
583             // 512 by 256 division.
584             ///////////////////////////////////////////////
585 
586             // Make division exact by subtracting the remainder from [prod1 prod0].
587             uint256 remainder;
588             assembly {
589                 // Compute remainder using mulmod.
590                 remainder := mulmod(x, y, denominator)
591 
592                 // Subtract 256 bit number from 512 bit number.
593                 prod1 := sub(prod1, gt(remainder, prod0))
594                 prod0 := sub(prod0, remainder)
595             }
596 
597             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
598             // See https://cs.stackexchange.com/q/138556/92363.
599 
600             // Does not overflow because the denominator cannot be zero at this stage in the function.
601             uint256 twos = denominator & (~denominator + 1);
602             assembly {
603                 // Divide denominator by twos.
604                 denominator := div(denominator, twos)
605 
606                 // Divide [prod1 prod0] by twos.
607                 prod0 := div(prod0, twos)
608 
609                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
610                 twos := add(div(sub(0, twos), twos), 1)
611             }
612 
613             // Shift in bits from prod1 into prod0.
614             prod0 |= prod1 * twos;
615 
616             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
617             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
618             // four bits. That is, denominator * inv = 1 mod 2^4.
619             uint256 inverse = (3 * denominator) ^ 2;
620 
621             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
622             // in modular arithmetic, doubling the correct bits in each step.
623             inverse *= 2 - denominator * inverse; // inverse mod 2^8
624             inverse *= 2 - denominator * inverse; // inverse mod 2^16
625             inverse *= 2 - denominator * inverse; // inverse mod 2^32
626             inverse *= 2 - denominator * inverse; // inverse mod 2^64
627             inverse *= 2 - denominator * inverse; // inverse mod 2^128
628             inverse *= 2 - denominator * inverse; // inverse mod 2^256
629 
630             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
631             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
632             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
633             // is no longer required.
634             result = prod0 * inverse;
635             return result;
636         }
637     }
638 
639     /**
640      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
641      */
642     function mulDiv(
643         uint256 x,
644         uint256 y,
645         uint256 denominator,
646         Rounding rounding
647     ) internal pure returns (uint256) {
648         uint256 result = mulDiv(x, y, denominator);
649         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
650             result += 1;
651         }
652         return result;
653     }
654 
655     /**
656      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
657      *
658      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
659      */
660     function sqrt(uint256 a) internal pure returns (uint256) {
661         if (a == 0) {
662             return 0;
663         }
664 
665         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
666         //
667         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
668         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
669         //
670         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
671         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
672         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
673         //
674         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
675         uint256 result = 1 << (log2(a) >> 1);
676 
677         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
678         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
679         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
680         // into the expected uint128 result.
681         unchecked {
682             result = (result + a / result) >> 1;
683             result = (result + a / result) >> 1;
684             result = (result + a / result) >> 1;
685             result = (result + a / result) >> 1;
686             result = (result + a / result) >> 1;
687             result = (result + a / result) >> 1;
688             result = (result + a / result) >> 1;
689             return min(result, a / result);
690         }
691     }
692 
693     /**
694      * @notice Calculates sqrt(a), following the selected rounding direction.
695      */
696     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
697         unchecked {
698             uint256 result = sqrt(a);
699             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
700         }
701     }
702 
703     /**
704      * @dev Return the log in base 2, rounded down, of a positive value.
705      * Returns 0 if given 0.
706      */
707     function log2(uint256 value) internal pure returns (uint256) {
708         uint256 result = 0;
709         unchecked {
710             if (value >> 128 > 0) {
711                 value >>= 128;
712                 result += 128;
713             }
714             if (value >> 64 > 0) {
715                 value >>= 64;
716                 result += 64;
717             }
718             if (value >> 32 > 0) {
719                 value >>= 32;
720                 result += 32;
721             }
722             if (value >> 16 > 0) {
723                 value >>= 16;
724                 result += 16;
725             }
726             if (value >> 8 > 0) {
727                 value >>= 8;
728                 result += 8;
729             }
730             if (value >> 4 > 0) {
731                 value >>= 4;
732                 result += 4;
733             }
734             if (value >> 2 > 0) {
735                 value >>= 2;
736                 result += 2;
737             }
738             if (value >> 1 > 0) {
739                 result += 1;
740             }
741         }
742         return result;
743     }
744 
745     /**
746      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
747      * Returns 0 if given 0.
748      */
749     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
750         unchecked {
751             uint256 result = log2(value);
752             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
753         }
754     }
755 
756     /**
757      * @dev Return the log in base 10, rounded down, of a positive value.
758      * Returns 0 if given 0.
759      */
760     function log10(uint256 value) internal pure returns (uint256) {
761         uint256 result = 0;
762         unchecked {
763             if (value >= 10**64) {
764                 value /= 10**64;
765                 result += 64;
766             }
767             if (value >= 10**32) {
768                 value /= 10**32;
769                 result += 32;
770             }
771             if (value >= 10**16) {
772                 value /= 10**16;
773                 result += 16;
774             }
775             if (value >= 10**8) {
776                 value /= 10**8;
777                 result += 8;
778             }
779             if (value >= 10**4) {
780                 value /= 10**4;
781                 result += 4;
782             }
783             if (value >= 10**2) {
784                 value /= 10**2;
785                 result += 2;
786             }
787             if (value >= 10**1) {
788                 result += 1;
789             }
790         }
791         return result;
792     }
793 
794     /**
795      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
796      * Returns 0 if given 0.
797      */
798     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
799         unchecked {
800             uint256 result = log10(value);
801             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
802         }
803     }
804 
805     /**
806      * @dev Return the log in base 256, rounded down, of a positive value.
807      * Returns 0 if given 0.
808      *
809      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
810      */
811     function log256(uint256 value) internal pure returns (uint256) {
812         uint256 result = 0;
813         unchecked {
814             if (value >> 128 > 0) {
815                 value >>= 128;
816                 result += 16;
817             }
818             if (value >> 64 > 0) {
819                 value >>= 64;
820                 result += 8;
821             }
822             if (value >> 32 > 0) {
823                 value >>= 32;
824                 result += 4;
825             }
826             if (value >> 16 > 0) {
827                 value >>= 16;
828                 result += 2;
829             }
830             if (value >> 8 > 0) {
831                 result += 1;
832             }
833         }
834         return result;
835     }
836 
837     /**
838      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
839      * Returns 0 if given 0.
840      */
841     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
842         unchecked {
843             uint256 result = log256(value);
844             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
845         }
846     }
847 }
848 
849 // File: @openzeppelin/contracts/utils/Strings.sol
850 
851 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 /**
856  * @dev String operations.
857  */
858 library Strings {
859     bytes16 private constant _SYMBOLS = "0123456789abcdef";
860     uint8 private constant _ADDRESS_LENGTH = 20;
861 
862     /**
863      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
864      */
865     function toString(uint256 value) internal pure returns (string memory) {
866         unchecked {
867             uint256 length = Math.log10(value) + 1;
868             string memory buffer = new string(length);
869             uint256 ptr;
870             /// @solidity memory-safe-assembly
871             assembly {
872                 ptr := add(buffer, add(32, length))
873             }
874             while (true) {
875                 ptr--;
876                 /// @solidity memory-safe-assembly
877                 assembly {
878                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
879                 }
880                 value /= 10;
881                 if (value == 0) break;
882             }
883             return buffer;
884         }
885     }
886 
887     /**
888      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
889      */
890     function toHexString(uint256 value) internal pure returns (string memory) {
891         unchecked {
892             return toHexString(value, Math.log256(value) + 1);
893         }
894     }
895 
896     /**
897      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
898      */
899     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
900         bytes memory buffer = new bytes(2 * length + 2);
901         buffer[0] = "0";
902         buffer[1] = "x";
903         for (uint256 i = 2 * length + 1; i > 1; --i) {
904             buffer[i] = _SYMBOLS[value & 0xf];
905             value >>= 4;
906         }
907         require(value == 0, "Strings: hex length insufficient");
908         return string(buffer);
909     }
910 
911     /**
912      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
913      */
914     function toHexString(address addr) internal pure returns (string memory) {
915         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
916     }
917 }
918 
919 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @dev Implementation of the {IERC165} interface.
927  *
928  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
929  * for the additional interface id that will be supported. For example:
930  *
931  * ```solidity
932  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
933  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
934  * }
935  * ```
936  *
937  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
938  */
939 abstract contract ERC165 is IERC165 {
940     /**
941      * @dev See {IERC165-supportsInterface}.
942      */
943     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
944         return interfaceId == type(IERC165).interfaceId;
945     }
946 }
947 
948 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
949 
950 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 
955 
956 
957 
958 
959 
960 /**
961  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
962  * the Metadata extension, but not including the Enumerable extension, which is available separately as
963  * {ERC721Enumerable}.
964  */
965 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
966     using Address for address;
967     using Strings for uint256;
968 
969     // Token name
970     string private _name;
971 
972     // Token symbol
973     string private _symbol;
974 
975     // Mapping from token ID to owner address
976     mapping(uint256 => address) private _owners;
977 
978     // Mapping owner address to token count
979     mapping(address => uint256) private _balances;
980 
981     // Mapping from token ID to approved address
982     mapping(uint256 => address) private _tokenApprovals;
983 
984     // Mapping from owner to operator approvals
985     mapping(address => mapping(address => bool)) private _operatorApprovals;
986 
987     /**
988      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
989      */
990     constructor(string memory name_, string memory symbol_) {
991         _name = name_;
992         _symbol = symbol_;
993     }
994 
995     /**
996      * @dev See {IERC165-supportsInterface}.
997      */
998     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
999         return
1000             interfaceId == type(IERC721).interfaceId ||
1001             interfaceId == type(IERC721Metadata).interfaceId ||
1002             super.supportsInterface(interfaceId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-balanceOf}.
1007      */
1008     function balanceOf(address owner) public view virtual override returns (uint256) {
1009         require(owner != address(0), "ERC721: address zero is not a valid owner");
1010         return _balances[owner];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-ownerOf}.
1015      */
1016     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1017         address owner = _ownerOf(tokenId);
1018         require(owner != address(0), "ERC721: invalid token ID");
1019         return owner;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-name}.
1024      */
1025     function name() public view virtual override returns (string memory) {
1026         return _name;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-symbol}.
1031      */
1032     function symbol() public view virtual override returns (string memory) {
1033         return _symbol;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-tokenURI}.
1038      */
1039     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1040         _requireMinted(tokenId);
1041 
1042         string memory baseURI = _baseURI();
1043         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1044     }
1045 
1046     /**
1047      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1048      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1049      * by default, can be overridden in child contracts.
1050      */
1051     function _baseURI() internal view virtual returns (string memory) {
1052         return "";
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-approve}.
1057      */
1058     function approve(address to, uint256 tokenId) public virtual override {
1059         address owner = ERC721.ownerOf(tokenId);
1060         require(to != owner, "ERC721: approval to current owner");
1061 
1062         require(
1063             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1064             "ERC721: approve caller is not token owner or approved for all"
1065         );
1066 
1067         _approve(to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-getApproved}.
1072      */
1073     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1074         _requireMinted(tokenId);
1075 
1076         return _tokenApprovals[tokenId];
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-setApprovalForAll}.
1081      */
1082     function setApprovalForAll(address operator, bool approved) public virtual override {
1083         _setApprovalForAll(_msgSender(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1090         return _operatorApprovals[owner][operator];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-transferFrom}.
1095      */
1096     function transferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         //solhint-disable-next-line max-line-length
1102         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1103 
1104         _transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-safeTransferFrom}.
1109      */
1110     function safeTransferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) public virtual override {
1115         safeTransferFrom(from, to, tokenId, "");
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-safeTransferFrom}.
1120      */
1121     function safeTransferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory data
1126     ) public virtual override {
1127         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1128         _safeTransfer(from, to, tokenId, data);
1129     }
1130 
1131     /**
1132      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1133      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1134      *
1135      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1136      *
1137      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1138      * implement alternative mechanisms to perform token transfer, such as signature-based.
1139      *
1140      * Requirements:
1141      *
1142      * - `from` cannot be the zero address.
1143      * - `to` cannot be the zero address.
1144      * - `tokenId` token must exist and be owned by `from`.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _safeTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId,
1153         bytes memory data
1154     ) internal virtual {
1155         _transfer(from, to, tokenId);
1156         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1157     }
1158 
1159     /**
1160      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1161      */
1162     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1163         return _owners[tokenId];
1164     }
1165 
1166     /**
1167      * @dev Returns whether `tokenId` exists.
1168      *
1169      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1170      *
1171      * Tokens start existing when they are minted (`_mint`),
1172      * and stop existing when they are burned (`_burn`).
1173      */
1174     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1175         return _ownerOf(tokenId) != address(0);
1176     }
1177 
1178     /**
1179      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must exist.
1184      */
1185     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1186         address owner = ERC721.ownerOf(tokenId);
1187         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1188     }
1189 
1190     /**
1191      * @dev Safely mints `tokenId` and transfers it to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must not exist.
1196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _safeMint(address to, uint256 tokenId) internal virtual {
1201         _safeMint(to, tokenId, "");
1202     }
1203 
1204     /**
1205      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1206      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1207      */
1208     function _safeMint(
1209         address to,
1210         uint256 tokenId,
1211         bytes memory data
1212     ) internal virtual {
1213         _mint(to, tokenId);
1214         require(
1215             _checkOnERC721Received(address(0), to, tokenId, data),
1216             "ERC721: transfer to non ERC721Receiver implementer"
1217         );
1218     }
1219 
1220     /**
1221      * @dev Mints `tokenId` and transfers it to `to`.
1222      *
1223      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must not exist.
1228      * - `to` cannot be the zero address.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _mint(address to, uint256 tokenId) internal virtual {
1233         require(to != address(0), "ERC721: mint to the zero address");
1234         require(!_exists(tokenId), "ERC721: token already minted");
1235 
1236         _beforeTokenTransfer(address(0), to, tokenId, 1);
1237 
1238         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1239         require(!_exists(tokenId), "ERC721: token already minted");
1240 
1241         unchecked {
1242             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1243             // Given that tokens are minted one by one, it is impossible in practice that
1244             // this ever happens. Might change if we allow batch minting.
1245             // The ERC fails to describe this case.
1246             _balances[to] += 1;
1247         }
1248 
1249         _owners[tokenId] = to;
1250 
1251         emit Transfer(address(0), to, tokenId);
1252 
1253         _afterTokenTransfer(address(0), to, tokenId, 1);
1254     }
1255 
1256     /**
1257      * @dev Destroys `tokenId`.
1258      * The approval is cleared when the token is burned.
1259      * This is an internal function that does not check if the sender is authorized to operate on the token.
1260      *
1261      * Requirements:
1262      *
1263      * - `tokenId` must exist.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _burn(uint256 tokenId) internal virtual {
1268         address owner = ERC721.ownerOf(tokenId);
1269 
1270         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1271 
1272         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1273         owner = ERC721.ownerOf(tokenId);
1274 
1275         // Clear approvals
1276         delete _tokenApprovals[tokenId];
1277 
1278         unchecked {
1279             // Cannot overflow, as that would require more tokens to be burned/transferred
1280             // out than the owner initially received through minting and transferring in.
1281             _balances[owner] -= 1;
1282         }
1283         delete _owners[tokenId];
1284 
1285         emit Transfer(owner, address(0), tokenId);
1286 
1287         _afterTokenTransfer(owner, address(0), tokenId, 1);
1288     }
1289 
1290     /**
1291      * @dev Transfers `tokenId` from `from` to `to`.
1292      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1293      *
1294      * Requirements:
1295      *
1296      * - `to` cannot be the zero address.
1297      * - `tokenId` token must be owned by `from`.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _transfer(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) internal virtual {
1306         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1307         require(to != address(0), "ERC721: transfer to the zero address");
1308 
1309         _beforeTokenTransfer(from, to, tokenId, 1);
1310 
1311         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1312         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1313 
1314         // Clear approvals from the previous owner
1315         delete _tokenApprovals[tokenId];
1316 
1317         unchecked {
1318             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1319             // `from`'s balance is the number of token held, which is at least one before the current
1320             // transfer.
1321             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1322             // all 2**256 token ids to be minted, which in practice is impossible.
1323             _balances[from] -= 1;
1324             _balances[to] += 1;
1325         }
1326         _owners[tokenId] = to;
1327 
1328         emit Transfer(from, to, tokenId);
1329 
1330         _afterTokenTransfer(from, to, tokenId, 1);
1331     }
1332 
1333     /**
1334      * @dev Approve `to` to operate on `tokenId`
1335      *
1336      * Emits an {Approval} event.
1337      */
1338     function _approve(address to, uint256 tokenId) internal virtual {
1339         _tokenApprovals[tokenId] = to;
1340         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Approve `operator` to operate on all of `owner` tokens
1345      *
1346      * Emits an {ApprovalForAll} event.
1347      */
1348     function _setApprovalForAll(
1349         address owner,
1350         address operator,
1351         bool approved
1352     ) internal virtual {
1353         require(owner != operator, "ERC721: approve to caller");
1354         _operatorApprovals[owner][operator] = approved;
1355         emit ApprovalForAll(owner, operator, approved);
1356     }
1357 
1358     /**
1359      * @dev Reverts if the `tokenId` has not been minted yet.
1360      */
1361     function _requireMinted(uint256 tokenId) internal view virtual {
1362         require(_exists(tokenId), "ERC721: invalid token ID");
1363     }
1364 
1365     /**
1366      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1367      * The call is not executed if the target address is not a contract.
1368      *
1369      * @param from address representing the previous owner of the given token ID
1370      * @param to target address that will receive the tokens
1371      * @param tokenId uint256 ID of the token to be transferred
1372      * @param data bytes optional data to send along with the call
1373      * @return bool whether the call correctly returned the expected magic value
1374      */
1375     function _checkOnERC721Received(
1376         address from,
1377         address to,
1378         uint256 tokenId,
1379         bytes memory data
1380     ) private returns (bool) {
1381         if (to.isContract()) {
1382             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1383                 return retval == IERC721Receiver.onERC721Received.selector;
1384             } catch (bytes memory reason) {
1385                 if (reason.length == 0) {
1386                     revert("ERC721: transfer to non ERC721Receiver implementer");
1387                 } else {
1388                     /// @solidity memory-safe-assembly
1389                     assembly {
1390                         revert(add(32, reason), mload(reason))
1391                     }
1392                 }
1393             }
1394         } else {
1395             return true;
1396         }
1397     }
1398 
1399     /**
1400      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1401      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1406      * - When `from` is zero, the tokens will be minted for `to`.
1407      * - When `to` is zero, ``from``'s tokens will be burned.
1408      * - `from` and `to` are never both zero.
1409      * - `batchSize` is non-zero.
1410      *
1411      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1412      */
1413     function _beforeTokenTransfer(
1414         address from,
1415         address to,
1416         uint256, /* firstTokenId */
1417         uint256 batchSize
1418     ) internal virtual {
1419         if (batchSize > 1) {
1420             if (from != address(0)) {
1421                 _balances[from] -= batchSize;
1422             }
1423             if (to != address(0)) {
1424                 _balances[to] += batchSize;
1425             }
1426         }
1427     }
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
1449 }
1450 
1451 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1452 
1453 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 /**
1458  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1459  * @dev See https://eips.ethereum.org/EIPS/eip-721
1460  */
1461 interface IERC721Enumerable is IERC721 {
1462     /**
1463      * @dev Returns the total amount of tokens stored by the contract.
1464      */
1465     function totalSupply() external view returns (uint256);
1466 
1467     /**
1468      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1469      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1470      */
1471     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1472 
1473     /**
1474      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1475      * Use along with {totalSupply} to enumerate all tokens.
1476      */
1477     function tokenByIndex(uint256 index) external view returns (uint256);
1478 }
1479 
1480 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1481 
1482 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1483 
1484 pragma solidity ^0.8.0;
1485 
1486 
1487 /**
1488  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1489  * enumerability of all the token ids in the contract as well as all token ids owned by each
1490  * account.
1491  */
1492 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1493     // Mapping from owner to list of owned token IDs
1494     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1495 
1496     // Mapping from token ID to index of the owner tokens list
1497     mapping(uint256 => uint256) private _ownedTokensIndex;
1498 
1499     // Array with all token ids, used for enumeration
1500     uint256[] private _allTokens;
1501 
1502     // Mapping from token id to position in the allTokens array
1503     mapping(uint256 => uint256) private _allTokensIndex;
1504 
1505     /**
1506      * @dev See {IERC165-supportsInterface}.
1507      */
1508     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1509         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1510     }
1511 
1512     /**
1513      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1514      */
1515     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1516         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1517         return _ownedTokens[owner][index];
1518     }
1519 
1520     /**
1521      * @dev See {IERC721Enumerable-totalSupply}.
1522      */
1523     function totalSupply() public view virtual override returns (uint256) {
1524         return _allTokens.length;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-tokenByIndex}.
1529      */
1530     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1531         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1532         return _allTokens[index];
1533     }
1534 
1535     /**
1536      * @dev See {ERC721-_beforeTokenTransfer}.
1537      */
1538     function _beforeTokenTransfer(
1539         address from,
1540         address to,
1541         uint256 firstTokenId,
1542         uint256 batchSize
1543     ) internal virtual override {
1544         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1545 
1546         if (batchSize > 1) {
1547             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1548             revert("ERC721Enumerable: consecutive transfers not supported");
1549         }
1550 
1551         uint256 tokenId = firstTokenId;
1552 
1553         if (from == address(0)) {
1554             _addTokenToAllTokensEnumeration(tokenId);
1555         } else if (from != to) {
1556             _removeTokenFromOwnerEnumeration(from, tokenId);
1557         }
1558         if (to == address(0)) {
1559             _removeTokenFromAllTokensEnumeration(tokenId);
1560         } else if (to != from) {
1561             _addTokenToOwnerEnumeration(to, tokenId);
1562         }
1563     }
1564 
1565     /**
1566      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1567      * @param to address representing the new owner of the given token ID
1568      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1569      */
1570     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1571         uint256 length = ERC721.balanceOf(to);
1572         _ownedTokens[to][length] = tokenId;
1573         _ownedTokensIndex[tokenId] = length;
1574     }
1575 
1576     /**
1577      * @dev Private function to add a token to this extension's token tracking data structures.
1578      * @param tokenId uint256 ID of the token to be added to the tokens list
1579      */
1580     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1581         _allTokensIndex[tokenId] = _allTokens.length;
1582         _allTokens.push(tokenId);
1583     }
1584 
1585     /**
1586      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1587      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1588      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1589      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1590      * @param from address representing the previous owner of the given token ID
1591      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1592      */
1593     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1594         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1595         // then delete the last slot (swap and pop).
1596 
1597         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1598         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1599 
1600         // When the token to delete is the last token, the swap operation is unnecessary
1601         if (tokenIndex != lastTokenIndex) {
1602             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1603 
1604             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1605             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1606         }
1607 
1608         // This also deletes the contents at the last position of the array
1609         delete _ownedTokensIndex[tokenId];
1610         delete _ownedTokens[from][lastTokenIndex];
1611     }
1612 
1613     /**
1614      * @dev Private function to remove a token from this extension's token tracking data structures.
1615      * This has O(1) time complexity, but alters the order of the _allTokens array.
1616      * @param tokenId uint256 ID of the token to be removed from the tokens list
1617      */
1618     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1619         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1620         // then delete the last slot (swap and pop).
1621 
1622         uint256 lastTokenIndex = _allTokens.length - 1;
1623         uint256 tokenIndex = _allTokensIndex[tokenId];
1624 
1625         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1626         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1627         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1628         uint256 lastTokenId = _allTokens[lastTokenIndex];
1629 
1630         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1631         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1632 
1633         // This also deletes the contents at the last position of the array
1634         delete _allTokensIndex[tokenId];
1635         _allTokens.pop();
1636     }
1637 }
1638 
1639 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1640 
1641 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 /**
1646  * @dev ERC721 token with storage based token URI management.
1647  */
1648 abstract contract ERC721URIStorage is ERC721 {
1649     using Strings for uint256;
1650 
1651     // Optional mapping for token URIs
1652     mapping(uint256 => string) private _tokenURIs;
1653 
1654     /**
1655      * @dev See {IERC721Metadata-tokenURI}.
1656      */
1657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1658         _requireMinted(tokenId);
1659 
1660         string memory _tokenURI = _tokenURIs[tokenId];
1661         string memory base = _baseURI();
1662 
1663         // If there is no base URI, return the token URI.
1664         if (bytes(base).length == 0) {
1665             return _tokenURI;
1666         }
1667         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1668         if (bytes(_tokenURI).length > 0) {
1669             return string(abi.encodePacked(base, _tokenURI));
1670         }
1671 
1672         return super.tokenURI(tokenId);
1673     }
1674 
1675     /**
1676      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must exist.
1681      */
1682     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1683         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1684         _tokenURIs[tokenId] = _tokenURI;
1685     }
1686 
1687     /**
1688      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1689      * token-specific URI was set for the token, and if so, it deletes the token URI from
1690      * the storage mapping.
1691      */
1692     function _burn(uint256 tokenId) internal virtual override {
1693         super._burn(tokenId);
1694 
1695         if (bytes(_tokenURIs[tokenId]).length != 0) {
1696             delete _tokenURIs[tokenId];
1697         }
1698     }
1699 }
1700 
1701 // File: @openzeppelin/contracts/security/Pausable.sol
1702 
1703 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1704 
1705 pragma solidity ^0.8.0;
1706 
1707 /**
1708  * @dev Contract module which allows children to implement an emergency stop
1709  * mechanism that can be triggered by an authorized account.
1710  *
1711  * This module is used through inheritance. It will make available the
1712  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1713  * the functions of your contract. Note that they will not be pausable by
1714  * simply including this module, only once the modifiers are put in place.
1715  */
1716 abstract contract Pausable is Context {
1717     /**
1718      * @dev Emitted when the pause is triggered by `account`.
1719      */
1720     event Paused(address account);
1721 
1722     /**
1723      * @dev Emitted when the pause is lifted by `account`.
1724      */
1725     event Unpaused(address account);
1726 
1727     bool private _paused;
1728 
1729     /**
1730      * @dev Initializes the contract in unpaused state.
1731      */
1732     constructor() {
1733         _paused = false;
1734     }
1735 
1736     /**
1737      * @dev Modifier to make a function callable only when the contract is not paused.
1738      *
1739      * Requirements:
1740      *
1741      * - The contract must not be paused.
1742      */
1743     modifier whenNotPaused() {
1744         _requireNotPaused();
1745         _;
1746     }
1747 
1748     /**
1749      * @dev Modifier to make a function callable only when the contract is paused.
1750      *
1751      * Requirements:
1752      *
1753      * - The contract must be paused.
1754      */
1755     modifier whenPaused() {
1756         _requirePaused();
1757         _;
1758     }
1759 
1760     /**
1761      * @dev Returns true if the contract is paused, and false otherwise.
1762      */
1763     function paused() public view virtual returns (bool) {
1764         return _paused;
1765     }
1766 
1767     /**
1768      * @dev Throws if the contract is paused.
1769      */
1770     function _requireNotPaused() internal view virtual {
1771         require(!paused(), "Pausable: paused");
1772     }
1773 
1774     /**
1775      * @dev Throws if the contract is not paused.
1776      */
1777     function _requirePaused() internal view virtual {
1778         require(paused(), "Pausable: not paused");
1779     }
1780 
1781     /**
1782      * @dev Triggers stopped state.
1783      *
1784      * Requirements:
1785      *
1786      * - The contract must not be paused.
1787      */
1788     function _pause() internal virtual whenNotPaused {
1789         _paused = true;
1790         emit Paused(_msgSender());
1791     }
1792 
1793     /**
1794      * @dev Returns to normal state.
1795      *
1796      * Requirements:
1797      *
1798      * - The contract must be paused.
1799      */
1800     function _unpause() internal virtual whenPaused {
1801         _paused = false;
1802         emit Unpaused(_msgSender());
1803     }
1804 }
1805 
1806 // File: @openzeppelin/contracts/access/Ownable.sol
1807 
1808 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1809 
1810 pragma solidity ^0.8.0;
1811 
1812 /**
1813  * @dev Contract module which provides a basic access control mechanism, where
1814  * there is an account (an owner) that can be granted exclusive access to
1815  * specific functions.
1816  *
1817  * By default, the owner account will be the one that deploys the contract. This
1818  * can later be changed with {transferOwnership}.
1819  *
1820  * This module is used through inheritance. It will make available the modifier
1821  * `onlyOwner`, which can be applied to your functions to restrict their use to
1822  * the owner.
1823  */
1824 abstract contract Ownable is Context {
1825     address private _owner;
1826 
1827     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1828 
1829     /**
1830      * @dev Initializes the contract setting the deployer as the initial owner.
1831      */
1832     constructor() {
1833         _transferOwnership(_msgSender());
1834     }
1835 
1836     /**
1837      * @dev Throws if called by any account other than the owner.
1838      */
1839     modifier onlyOwner() {
1840         _checkOwner();
1841         _;
1842     }
1843 
1844     /**
1845      * @dev Returns the address of the current owner.
1846      */
1847     function owner() public view virtual returns (address) {
1848         return _owner;
1849     }
1850 
1851     /**
1852      * @dev Throws if the sender is not the owner.
1853      */
1854     function _checkOwner() internal view virtual {
1855         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1856     }
1857 
1858     /**
1859      * @dev Leaves the contract without owner. It will not be possible to call
1860      * `onlyOwner` functions anymore. Can only be called by the current owner.
1861      *
1862      * NOTE: Renouncing ownership will leave the contract without an owner,
1863      * thereby removing any functionality that is only available to the owner.
1864      */
1865     function renounceOwnership() public virtual onlyOwner {
1866         _transferOwnership(address(0));
1867     }
1868 
1869     /**
1870      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1871      * Can only be called by the current owner.
1872      */
1873     function transferOwnership(address newOwner) public virtual onlyOwner {
1874         require(newOwner != address(0), "Ownable: new owner is the zero address");
1875         _transferOwnership(newOwner);
1876     }
1877 
1878     /**
1879      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1880      * Internal function without access restriction.
1881      */
1882     function _transferOwnership(address newOwner) internal virtual {
1883         address oldOwner = _owner;
1884         _owner = newOwner;
1885         emit OwnershipTransferred(oldOwner, newOwner);
1886     }
1887 }
1888 
1889 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1890 
1891 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1892 
1893 pragma solidity ^0.8.0;
1894 
1895 
1896 /**
1897  * @title ERC721 Burnable Token
1898  * @dev ERC721 Token that can be burned (destroyed).
1899  */
1900 abstract contract ERC721Burnable is Context, ERC721 {
1901     /**
1902      * @dev Burns `tokenId`. See {ERC721-_burn}.
1903      *
1904      * Requirements:
1905      *
1906      * - The caller must own `tokenId` or be an approved operator.
1907      */
1908     function burn(uint256 tokenId) public virtual {
1909         //solhint-disable-next-line max-line-length
1910         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1911         _burn(tokenId);
1912     }
1913 }
1914 
1915 // File: @openzeppelin/contracts/utils/Counters.sol
1916 
1917 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1918 
1919 pragma solidity ^0.8.0;
1920 
1921 /**
1922  * @title Counters
1923  * @author Matt Condon (@shrugs)
1924  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1925  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1926  *
1927  * Include with `using Counters for Counters.Counter;`
1928  */
1929 library Counters {
1930     struct Counter {
1931         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1932         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1933         // this feature: see https://github.com/ethereum/solidity/issues/4637
1934         uint256 _value; // default: 0
1935     }
1936 
1937     function current(Counter storage counter) internal view returns (uint256) {
1938         return counter._value;
1939     }
1940 
1941     function increment(Counter storage counter) internal {
1942         unchecked {
1943             counter._value += 1;
1944         }
1945     }
1946 
1947     function decrement(Counter storage counter) internal {
1948         uint256 value = counter._value;
1949         require(value > 0, "Counter: decrement overflow");
1950         unchecked {
1951             counter._value = value - 1;
1952         }
1953     }
1954 
1955     function reset(Counter storage counter) internal {
1956         counter._value = 0;
1957     }
1958 }
1959 
1960 // File: MIANFT.sol
1961 
1962 pragma solidity ^0.8.9;
1963 contract MIAToken is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1964     using Counters for Counters.Counter;
1965 
1966     Counters.Counter private _tokenIdCounter;
1967 
1968     uint256 MAX_SUPPLY = 2000;
1969 
1970     constructor() ERC721("Mia", "MIA") {}
1971 
1972     function pause() public onlyOwner {
1973         _pause();
1974     }
1975 
1976     function unpause() public onlyOwner {
1977         _unpause();
1978     }
1979 
1980     function mintById(address to, string memory uri,uint256 id) public onlyOwner{
1981         require(id <= MAX_SUPPLY, "mint max error!");
1982         _safeMint(to, id);
1983         _setTokenURI(id, uri);
1984     }
1985 
1986     function safeMint(address to, string memory uri) public onlyOwner {
1987         uint256 tokenId = _tokenIdCounter.current();
1988         require(_tokenIdCounter.current() <= MAX_SUPPLY, "mint max error!");
1989         _tokenIdCounter.increment();
1990         _safeMint(to, tokenId);
1991         _setTokenURI(tokenId, uri);
1992     }
1993 
1994     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
1995         internal
1996         whenNotPaused
1997         override(ERC721, ERC721Enumerable)
1998     {
1999         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2000     }
2001 
2002 
2003     function _burn(uint256 tokenId) internal onlyOwner override(ERC721, ERC721URIStorage) {
2004         super._burn(tokenId);
2005     }
2006 
2007     function tokenURI(uint256 tokenId)
2008         public
2009         view
2010         override(ERC721, ERC721URIStorage)
2011         returns (string memory)
2012     {
2013         return super.tokenURI(tokenId);
2014     }
2015 
2016     function supportsInterface(bytes4 interfaceId)
2017         public
2018         view
2019         override(ERC721, ERC721Enumerable)
2020         returns (bool)
2021     {
2022         return super.supportsInterface(interfaceId);
2023     }
2024 }