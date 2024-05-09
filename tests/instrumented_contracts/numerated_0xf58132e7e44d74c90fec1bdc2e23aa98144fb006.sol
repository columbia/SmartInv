1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId,
79         bytes calldata data
80     ) external;
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
106      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
107      * understand this adds an external call which potentially creates a reentrancy vulnerability.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns the account approved for `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function getApproved(uint256 tokenId) external view returns (address operator);
159 
160     /**
161      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162      *
163      * See {setApprovalForAll}
164      */
165     function isApprovedForAll(address owner, address operator) external view returns (bool);
166 }
167 
168 
169 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
170 /**
171  * @title ERC721 token receiver interface
172  * @dev Interface for any contract that wants to support safeTransfers
173  * from ERC721 asset contracts.
174  */
175 interface IERC721Receiver {
176     /**
177      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
178      * by `operator` from `from`, this function is called.
179      *
180      * It must return its Solidity selector to confirm the token transfer.
181      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
182      *
183      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
184      */
185     function onERC721Received(
186         address operator,
187         address from,
188         uint256 tokenId,
189         bytes calldata data
190     ) external returns (bytes4);
191 }
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
197  * @dev See https://eips.ethereum.org/EIPS/eip-721
198  */
199 interface IERC721Metadata is IERC721 {
200     /**
201      * @dev Returns the token collection name.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the token collection symbol.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
212      */
213     function tokenURI(uint256 tokenId) external view returns (string memory);
214 }
215 
216 
217 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * [IMPORTANT]
226      * ====
227      * It is unsafe to assume that an address for which this function returns
228      * false is an externally-owned account (EOA) and not a contract.
229      *
230      * Among others, `isContract` will return false for the following
231      * types of addresses:
232      *
233      *  - an externally-owned account
234      *  - a contract in construction
235      *  - an address where a contract will be created
236      *  - an address where a contract lived, but was destroyed
237      * ====
238      *
239      * [IMPORTANT]
240      * ====
241      * You shouldn't rely on `isContract` to protect against flash loan attacks!
242      *
243      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
244      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
245      * constructor.
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies on extcodesize/address.code.length, which returns 0
250         // for contracts in construction, since the code is only stored at the end
251         // of the constructor execution.
252 
253         return account.code.length > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
403      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
404      *
405      * _Available since v4.8._
406      */
407     function verifyCallResultFromTarget(
408         address target,
409         bool success,
410         bytes memory returndata,
411         string memory errorMessage
412     ) internal view returns (bytes memory) {
413         if (success) {
414             if (returndata.length == 0) {
415                 // only check isContract if the call was successful and the return data is empty
416                 // otherwise we already know that it was a contract
417                 require(isContract(target), "Address: call to non-contract");
418             }
419             return returndata;
420         } else {
421             _revert(returndata, errorMessage);
422         }
423     }
424 
425     /**
426      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
427      * revert reason or using the provided one.
428      *
429      * _Available since v4.3._
430      */
431     function verifyCallResult(
432         bool success,
433         bytes memory returndata,
434         string memory errorMessage
435     ) internal pure returns (bytes memory) {
436         if (success) {
437             return returndata;
438         } else {
439             _revert(returndata, errorMessage);
440         }
441     }
442 
443     function _revert(bytes memory returndata, string memory errorMessage) private pure {
444         // Look for revert reason and bubble it up if present
445         if (returndata.length > 0) {
446             // The easiest way to bubble the revert reason is using memory via assembly
447             /// @solidity memory-safe-assembly
448             assembly {
449                 let returndata_size := mload(returndata)
450                 revert(add(32, returndata), returndata_size)
451             }
452         } else {
453             revert(errorMessage);
454         }
455     }
456 }
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
460 /**
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 
480 
481 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
482 /**
483  * @dev Standard math utilities missing in the Solidity language.
484  */
485 library Math {
486     enum Rounding {
487         Down, // Toward negative infinity
488         Up, // Toward infinity
489         Zero // Toward zero
490     }
491 
492     /**
493      * @dev Returns the largest of two numbers.
494      */
495     function max(uint256 a, uint256 b) internal pure returns (uint256) {
496         return a > b ? a : b;
497     }
498 
499     /**
500      * @dev Returns the smallest of two numbers.
501      */
502     function min(uint256 a, uint256 b) internal pure returns (uint256) {
503         return a < b ? a : b;
504     }
505 
506     /**
507      * @dev Returns the average of two numbers. The result is rounded towards
508      * zero.
509      */
510     function average(uint256 a, uint256 b) internal pure returns (uint256) {
511         // (a + b) / 2 can overflow.
512         return (a & b) + (a ^ b) / 2;
513     }
514 
515     /**
516      * @dev Returns the ceiling of the division of two numbers.
517      *
518      * This differs from standard division with `/` in that it rounds up instead
519      * of rounding down.
520      */
521     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
522         // (a + b - 1) / b can overflow on addition, so we distribute.
523         return a == 0 ? 0 : (a - 1) / b + 1;
524     }
525 
526     /**
527      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
528      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
529      * with further edits by Uniswap Labs also under MIT license.
530      */
531     function mulDiv(
532         uint256 x,
533         uint256 y,
534         uint256 denominator
535     ) internal pure returns (uint256 result) {
536         unchecked {
537             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
538             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
539             // variables such that product = prod1 * 2^256 + prod0.
540             uint256 prod0; // Least significant 256 bits of the product
541             uint256 prod1; // Most significant 256 bits of the product
542             assembly {
543                 let mm := mulmod(x, y, not(0))
544                 prod0 := mul(x, y)
545                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
546             }
547 
548             // Handle non-overflow cases, 256 by 256 division.
549             if (prod1 == 0) {
550                 return prod0 / denominator;
551             }
552 
553             // Make sure the result is less than 2^256. Also prevents denominator == 0.
554             require(denominator > prod1);
555 
556             ///////////////////////////////////////////////
557             // 512 by 256 division.
558             ///////////////////////////////////////////////
559 
560             // Make division exact by subtracting the remainder from [prod1 prod0].
561             uint256 remainder;
562             assembly {
563                 // Compute remainder using mulmod.
564                 remainder := mulmod(x, y, denominator)
565 
566                 // Subtract 256 bit number from 512 bit number.
567                 prod1 := sub(prod1, gt(remainder, prod0))
568                 prod0 := sub(prod0, remainder)
569             }
570 
571             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
572             // See https://cs.stackexchange.com/q/138556/92363.
573 
574             // Does not overflow because the denominator cannot be zero at this stage in the function.
575             uint256 twos = denominator & (~denominator + 1);
576             assembly {
577                 // Divide denominator by twos.
578                 denominator := div(denominator, twos)
579 
580                 // Divide [prod1 prod0] by twos.
581                 prod0 := div(prod0, twos)
582 
583                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
584                 twos := add(div(sub(0, twos), twos), 1)
585             }
586 
587             // Shift in bits from prod1 into prod0.
588             prod0 |= prod1 * twos;
589 
590             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
591             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
592             // four bits. That is, denominator * inv = 1 mod 2^4.
593             uint256 inverse = (3 * denominator) ^ 2;
594 
595             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
596             // in modular arithmetic, doubling the correct bits in each step.
597             inverse *= 2 - denominator * inverse; // inverse mod 2^8
598             inverse *= 2 - denominator * inverse; // inverse mod 2^16
599             inverse *= 2 - denominator * inverse; // inverse mod 2^32
600             inverse *= 2 - denominator * inverse; // inverse mod 2^64
601             inverse *= 2 - denominator * inverse; // inverse mod 2^128
602             inverse *= 2 - denominator * inverse; // inverse mod 2^256
603 
604             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
605             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
606             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
607             // is no longer required.
608             result = prod0 * inverse;
609             return result;
610         }
611     }
612 
613     /**
614      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
615      */
616     function mulDiv(
617         uint256 x,
618         uint256 y,
619         uint256 denominator,
620         Rounding rounding
621     ) internal pure returns (uint256) {
622         uint256 result = mulDiv(x, y, denominator);
623         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
624             result += 1;
625         }
626         return result;
627     }
628 
629     /**
630      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
631      *
632      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
633      */
634     function sqrt(uint256 a) internal pure returns (uint256) {
635         if (a == 0) {
636             return 0;
637         }
638 
639         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
640         //
641         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
642         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
643         //
644         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
645         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
646         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
647         //
648         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
649         uint256 result = 1 << (log2(a) >> 1);
650 
651         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
652         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
653         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
654         // into the expected uint128 result.
655         unchecked {
656             result = (result + a / result) >> 1;
657             result = (result + a / result) >> 1;
658             result = (result + a / result) >> 1;
659             result = (result + a / result) >> 1;
660             result = (result + a / result) >> 1;
661             result = (result + a / result) >> 1;
662             result = (result + a / result) >> 1;
663             return min(result, a / result);
664         }
665     }
666 
667     /**
668      * @notice Calculates sqrt(a), following the selected rounding direction.
669      */
670     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
671         unchecked {
672             uint256 result = sqrt(a);
673             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
674         }
675     }
676 
677     /**
678      * @dev Return the log in base 2, rounded down, of a positive value.
679      * Returns 0 if given 0.
680      */
681     function log2(uint256 value) internal pure returns (uint256) {
682         uint256 result = 0;
683         unchecked {
684             if (value >> 128 > 0) {
685                 value >>= 128;
686                 result += 128;
687             }
688             if (value >> 64 > 0) {
689                 value >>= 64;
690                 result += 64;
691             }
692             if (value >> 32 > 0) {
693                 value >>= 32;
694                 result += 32;
695             }
696             if (value >> 16 > 0) {
697                 value >>= 16;
698                 result += 16;
699             }
700             if (value >> 8 > 0) {
701                 value >>= 8;
702                 result += 8;
703             }
704             if (value >> 4 > 0) {
705                 value >>= 4;
706                 result += 4;
707             }
708             if (value >> 2 > 0) {
709                 value >>= 2;
710                 result += 2;
711             }
712             if (value >> 1 > 0) {
713                 result += 1;
714             }
715         }
716         return result;
717     }
718 
719     /**
720      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
721      * Returns 0 if given 0.
722      */
723     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
724         unchecked {
725             uint256 result = log2(value);
726             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
727         }
728     }
729 
730     /**
731      * @dev Return the log in base 10, rounded down, of a positive value.
732      * Returns 0 if given 0.
733      */
734     function log10(uint256 value) internal pure returns (uint256) {
735         uint256 result = 0;
736         unchecked {
737             if (value >= 10**64) {
738                 value /= 10**64;
739                 result += 64;
740             }
741             if (value >= 10**32) {
742                 value /= 10**32;
743                 result += 32;
744             }
745             if (value >= 10**16) {
746                 value /= 10**16;
747                 result += 16;
748             }
749             if (value >= 10**8) {
750                 value /= 10**8;
751                 result += 8;
752             }
753             if (value >= 10**4) {
754                 value /= 10**4;
755                 result += 4;
756             }
757             if (value >= 10**2) {
758                 value /= 10**2;
759                 result += 2;
760             }
761             if (value >= 10**1) {
762                 result += 1;
763             }
764         }
765         return result;
766     }
767 
768     /**
769      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
770      * Returns 0 if given 0.
771      */
772     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
773         unchecked {
774             uint256 result = log10(value);
775             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
776         }
777     }
778 
779     /**
780      * @dev Return the log in base 256, rounded down, of a positive value.
781      * Returns 0 if given 0.
782      *
783      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
784      */
785     function log256(uint256 value) internal pure returns (uint256) {
786         uint256 result = 0;
787         unchecked {
788             if (value >> 128 > 0) {
789                 value >>= 128;
790                 result += 16;
791             }
792             if (value >> 64 > 0) {
793                 value >>= 64;
794                 result += 8;
795             }
796             if (value >> 32 > 0) {
797                 value >>= 32;
798                 result += 4;
799             }
800             if (value >> 16 > 0) {
801                 value >>= 16;
802                 result += 2;
803             }
804             if (value >> 8 > 0) {
805                 result += 1;
806             }
807         }
808         return result;
809     }
810 
811     /**
812      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
813      * Returns 0 if given 0.
814      */
815     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
816         unchecked {
817             uint256 result = log256(value);
818             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
819         }
820     }
821 }
822 
823 
824 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
825 /**
826  * @dev String operations.
827  */
828 library Strings {
829     bytes16 private constant _SYMBOLS = "0123456789abcdef";
830     uint8 private constant _ADDRESS_LENGTH = 20;
831 
832     /**
833      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
834      */
835     function toString(uint256 value) internal pure returns (string memory) {
836         unchecked {
837             uint256 length = Math.log10(value) + 1;
838             string memory buffer = new string(length);
839             uint256 ptr;
840             /// @solidity memory-safe-assembly
841             assembly {
842                 ptr := add(buffer, add(32, length))
843             }
844             while (true) {
845                 ptr--;
846                 /// @solidity memory-safe-assembly
847                 assembly {
848                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
849                 }
850                 value /= 10;
851                 if (value == 0) break;
852             }
853             return buffer;
854         }
855     }
856 
857     /**
858      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
859      */
860     function toHexString(uint256 value) internal pure returns (string memory) {
861         unchecked {
862             return toHexString(value, Math.log256(value) + 1);
863         }
864     }
865 
866     /**
867      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
868      */
869     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
870         bytes memory buffer = new bytes(2 * length + 2);
871         buffer[0] = "0";
872         buffer[1] = "x";
873         for (uint256 i = 2 * length + 1; i > 1; --i) {
874             buffer[i] = _SYMBOLS[value & 0xf];
875             value >>= 4;
876         }
877         require(value == 0, "Strings: hex length insufficient");
878         return string(buffer);
879     }
880 
881     /**
882      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
883      */
884     function toHexString(address addr) internal pure returns (string memory) {
885         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
886     }
887 }
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
891 /**
892  * @dev Implementation of the {IERC165} interface.
893  *
894  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
895  * for the additional interface id that will be supported. For example:
896  *
897  * ```solidity
898  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
899  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
900  * }
901  * ```
902  *
903  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
904  */
905 abstract contract ERC165 is IERC165 {
906     /**
907      * @dev See {IERC165-supportsInterface}.
908      */
909     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
910         return interfaceId == type(IERC165).interfaceId;
911     }
912 }
913 
914 
915 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
916 /**
917  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
918  * the Metadata extension, but not including the Enumerable extension, which is available separately as
919  * {ERC721Enumerable}.
920  */
921 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
922     using Address for address;
923     using Strings for uint256;
924 
925     // Token name
926     string private _name;
927 
928     // Token symbol
929     string private _symbol;
930 
931     // Mapping from token ID to owner address
932     mapping(uint256 => address) private _owners;
933 
934     // Mapping owner address to token count
935     mapping(address => uint256) private _balances;
936 
937     // Mapping from token ID to approved address
938     mapping(uint256 => address) private _tokenApprovals;
939 
940     // Mapping from owner to operator approvals
941     mapping(address => mapping(address => bool)) private _operatorApprovals;
942 
943     /**
944      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
945      */
946     constructor(string memory name_, string memory symbol_) {
947         _name = name_;
948         _symbol = symbol_;
949     }
950 
951     /**
952      * @dev See {IERC165-supportsInterface}.
953      */
954     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
955         return
956             interfaceId == type(IERC721).interfaceId ||
957             interfaceId == type(IERC721Metadata).interfaceId ||
958             super.supportsInterface(interfaceId);
959     }
960 
961     /**
962      * @dev See {IERC721-balanceOf}.
963      */
964     function balanceOf(address owner) public view virtual override returns (uint256) {
965         require(owner != address(0), "ERC721: address zero is not a valid owner");
966         return _balances[owner];
967     }
968 
969     /**
970      * @dev See {IERC721-ownerOf}.
971      */
972     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
973         address owner = _ownerOf(tokenId);
974         require(owner != address(0), "ERC721: invalid token ID");
975         return owner;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-name}.
980      */
981     function name() public view virtual override returns (string memory) {
982         return _name;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-symbol}.
987      */
988     function symbol() public view virtual override returns (string memory) {
989         return _symbol;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-tokenURI}.
994      */
995     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
996         _requireMinted(tokenId);
997 
998         string memory baseURI = _baseURI();
999         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1000     }
1001 
1002     /**
1003      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1004      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1005      * by default, can be overridden in child contracts.
1006      */
1007     function _baseURI() internal view virtual returns (string memory) {
1008         return "";
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-approve}.
1013      */
1014     function approve(address to, uint256 tokenId) public virtual override {
1015         address owner = ERC721.ownerOf(tokenId);
1016         require(to != owner, "ERC721: approval to current owner");
1017 
1018         require(
1019             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1020             "ERC721: approve caller is not token owner or approved for all"
1021         );
1022 
1023         _approve(to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-getApproved}.
1028      */
1029     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1030         _requireMinted(tokenId);
1031 
1032         return _tokenApprovals[tokenId];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-setApprovalForAll}.
1037      */
1038     function setApprovalForAll(address operator, bool approved) public virtual override {
1039         _setApprovalForAll(_msgSender(), operator, approved);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-isApprovedForAll}.
1044      */
1045     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1046         return _operatorApprovals[owner][operator];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-transferFrom}.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         //solhint-disable-next-line max-line-length
1058         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1059 
1060         _transfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) public virtual override {
1071         safeTransferFrom(from, to, tokenId, "");
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-safeTransferFrom}.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes memory data
1082     ) public virtual override {
1083         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1084         _safeTransfer(from, to, tokenId, data);
1085     }
1086 
1087     /**
1088      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1089      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1090      *
1091      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1092      *
1093      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1094      * implement alternative mechanisms to perform token transfer, such as signature-based.
1095      *
1096      * Requirements:
1097      *
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must exist and be owned by `from`.
1101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _safeTransfer(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory data
1110     ) internal virtual {
1111         _transfer(from, to, tokenId);
1112         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1113     }
1114 
1115     /**
1116      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1117      */
1118     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1119         return _owners[tokenId];
1120     }
1121 
1122     /**
1123      * @dev Returns whether `tokenId` exists.
1124      *
1125      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1126      *
1127      * Tokens start existing when they are minted (`_mint`),
1128      * and stop existing when they are burned (`_burn`).
1129      */
1130     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1131         return _ownerOf(tokenId) != address(0);
1132     }
1133 
1134     /**
1135      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1136      *
1137      * Requirements:
1138      *
1139      * - `tokenId` must exist.
1140      */
1141     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1142         address owner = ERC721.ownerOf(tokenId);
1143         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1144     }
1145 
1146     /**
1147      * @dev Safely mints `tokenId` and transfers it to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `tokenId` must not exist.
1152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _safeMint(address to, uint256 tokenId) internal virtual {
1157         _safeMint(to, tokenId, "");
1158     }
1159 
1160     /**
1161      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1162      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1163      */
1164     function _safeMint(
1165         address to,
1166         uint256 tokenId,
1167         bytes memory data
1168     ) internal virtual {
1169         _mint(to, tokenId);
1170         require(
1171             _checkOnERC721Received(address(0), to, tokenId, data),
1172             "ERC721: transfer to non ERC721Receiver implementer"
1173         );
1174     }
1175 
1176     /**
1177      * @dev Mints `tokenId` and transfers it to `to`.
1178      *
1179      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must not exist.
1184      * - `to` cannot be the zero address.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _mint(address to, uint256 tokenId) internal virtual {
1189         require(to != address(0), "ERC721: mint to the zero address");
1190         require(!_exists(tokenId), "ERC721: token already minted");
1191 
1192         _beforeTokenTransfer(address(0), to, tokenId, 1);
1193 
1194         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1195         require(!_exists(tokenId), "ERC721: token already minted");
1196 
1197         unchecked {
1198             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1199             // Given that tokens are minted one by one, it is impossible in practice that
1200             // this ever happens. Might change if we allow batch minting.
1201             // The ERC fails to describe this case.
1202             _balances[to] += 1;
1203         }
1204 
1205         _owners[tokenId] = to;
1206 
1207         emit Transfer(address(0), to, tokenId);
1208 
1209         _afterTokenTransfer(address(0), to, tokenId, 1);
1210     }
1211 
1212     /**
1213      * @dev Destroys `tokenId`.
1214      * The approval is cleared when the token is burned.
1215      * This is an internal function that does not check if the sender is authorized to operate on the token.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _burn(uint256 tokenId) internal virtual {
1224         address owner = ERC721.ownerOf(tokenId);
1225 
1226         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1227 
1228         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1229         owner = ERC721.ownerOf(tokenId);
1230 
1231         // Clear approvals
1232         delete _tokenApprovals[tokenId];
1233 
1234         unchecked {
1235             // Cannot overflow, as that would require more tokens to be burned/transferred
1236             // out than the owner initially received through minting and transferring in.
1237             _balances[owner] -= 1;
1238         }
1239         delete _owners[tokenId];
1240 
1241         emit Transfer(owner, address(0), tokenId);
1242 
1243         _afterTokenTransfer(owner, address(0), tokenId, 1);
1244     }
1245 
1246     /**
1247      * @dev Transfers `tokenId` from `from` to `to`.
1248      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1249      *
1250      * Requirements:
1251      *
1252      * - `to` cannot be the zero address.
1253      * - `tokenId` token must be owned by `from`.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _transfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) internal virtual {
1262         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1263         require(to != address(0), "ERC721: transfer to the zero address");
1264 
1265         _beforeTokenTransfer(from, to, tokenId, 1);
1266 
1267         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1268         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1269 
1270         // Clear approvals from the previous owner
1271         delete _tokenApprovals[tokenId];
1272 
1273         unchecked {
1274             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1275             // `from`'s balance is the number of token held, which is at least one before the current
1276             // transfer.
1277             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1278             // all 2**256 token ids to be minted, which in practice is impossible.
1279             _balances[from] -= 1;
1280             _balances[to] += 1;
1281         }
1282         _owners[tokenId] = to;
1283 
1284         emit Transfer(from, to, tokenId);
1285 
1286         _afterTokenTransfer(from, to, tokenId, 1);
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits an {Approval} event.
1293      */
1294     function _approve(address to, uint256 tokenId) internal virtual {
1295         _tokenApprovals[tokenId] = to;
1296         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1297     }
1298 
1299     /**
1300      * @dev Approve `operator` to operate on all of `owner` tokens
1301      *
1302      * Emits an {ApprovalForAll} event.
1303      */
1304     function _setApprovalForAll(
1305         address owner,
1306         address operator,
1307         bool approved
1308     ) internal virtual {
1309         require(owner != operator, "ERC721: approve to caller");
1310         _operatorApprovals[owner][operator] = approved;
1311         emit ApprovalForAll(owner, operator, approved);
1312     }
1313 
1314     /**
1315      * @dev Reverts if the `tokenId` has not been minted yet.
1316      */
1317     function _requireMinted(uint256 tokenId) internal view virtual {
1318         require(_exists(tokenId), "ERC721: invalid token ID");
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1323      * The call is not executed if the target address is not a contract.
1324      *
1325      * @param from address representing the previous owner of the given token ID
1326      * @param to target address that will receive the tokens
1327      * @param tokenId uint256 ID of the token to be transferred
1328      * @param data bytes optional data to send along with the call
1329      * @return bool whether the call correctly returned the expected magic value
1330      */
1331     function _checkOnERC721Received(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory data
1336     ) private returns (bool) {
1337         if (to.isContract()) {
1338             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1339                 return retval == IERC721Receiver.onERC721Received.selector;
1340             } catch (bytes memory reason) {
1341                 if (reason.length == 0) {
1342                     revert("ERC721: transfer to non ERC721Receiver implementer");
1343                 } else {
1344                     /// @solidity memory-safe-assembly
1345                     assembly {
1346                         revert(add(32, reason), mload(reason))
1347                     }
1348                 }
1349             }
1350         } else {
1351             return true;
1352         }
1353     }
1354 
1355     /**
1356      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1357      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1362      * - When `from` is zero, the tokens will be minted for `to`.
1363      * - When `to` is zero, ``from``'s tokens will be burned.
1364      * - `from` and `to` are never both zero.
1365      * - `batchSize` is non-zero.
1366      *
1367      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1368      */
1369     function _beforeTokenTransfer(
1370         address from,
1371         address to,
1372         uint256, /* firstTokenId */
1373         uint256 batchSize
1374     ) internal virtual {
1375         if (batchSize > 1) {
1376             if (from != address(0)) {
1377                 _balances[from] -= batchSize;
1378             }
1379             if (to != address(0)) {
1380                 _balances[to] += batchSize;
1381             }
1382         }
1383     }
1384 
1385     /**
1386      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1387      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1388      *
1389      * Calling conditions:
1390      *
1391      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1392      * - When `from` is zero, the tokens were minted for `to`.
1393      * - When `to` is zero, ``from``'s tokens were burned.
1394      * - `from` and `to` are never both zero.
1395      * - `batchSize` is non-zero.
1396      *
1397      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1398      */
1399     function _afterTokenTransfer(
1400         address from,
1401         address to,
1402         uint256 firstTokenId,
1403         uint256 batchSize
1404     ) internal virtual {}
1405 }
1406 
1407 
1408 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1409 /**
1410  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1411  * @dev See https://eips.ethereum.org/EIPS/eip-721
1412  */
1413 interface IERC721Enumerable is IERC721 {
1414     /**
1415      * @dev Returns the total amount of tokens stored by the contract.
1416      */
1417     function totalSupply() external view returns (uint256);
1418 
1419     /**
1420      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1421      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1422      */
1423     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1424 
1425     /**
1426      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1427      * Use along with {totalSupply} to enumerate all tokens.
1428      */
1429     function tokenByIndex(uint256 index) external view returns (uint256);
1430 }
1431 
1432 
1433 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1434 /**
1435  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1436  * enumerability of all the token ids in the contract as well as all token ids owned by each
1437  * account.
1438  */
1439 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1440     // Mapping from owner to list of owned token IDs
1441     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1442 
1443     // Mapping from token ID to index of the owner tokens list
1444     mapping(uint256 => uint256) private _ownedTokensIndex;
1445 
1446     // Array with all token ids, used for enumeration
1447     uint256[] private _allTokens;
1448 
1449     // Mapping from token id to position in the allTokens array
1450     mapping(uint256 => uint256) private _allTokensIndex;
1451 
1452     /**
1453      * @dev See {IERC165-supportsInterface}.
1454      */
1455     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1456         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1461      */
1462     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1463         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1464         return _ownedTokens[owner][index];
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Enumerable-totalSupply}.
1469      */
1470     function totalSupply() public view virtual override returns (uint256) {
1471         return _allTokens.length;
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Enumerable-tokenByIndex}.
1476      */
1477     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1478         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1479         return _allTokens[index];
1480     }
1481 
1482     /**
1483      * @dev See {ERC721-_beforeTokenTransfer}.
1484      */
1485     function _beforeTokenTransfer(
1486         address from,
1487         address to,
1488         uint256 firstTokenId,
1489         uint256 batchSize
1490     ) internal virtual override {
1491         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1492 
1493         if (batchSize > 1) {
1494             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1495             revert("ERC721Enumerable: consecutive transfers not supported");
1496         }
1497 
1498         uint256 tokenId = firstTokenId;
1499 
1500         if (from == address(0)) {
1501             _addTokenToAllTokensEnumeration(tokenId);
1502         } else if (from != to) {
1503             _removeTokenFromOwnerEnumeration(from, tokenId);
1504         }
1505         if (to == address(0)) {
1506             _removeTokenFromAllTokensEnumeration(tokenId);
1507         } else if (to != from) {
1508             _addTokenToOwnerEnumeration(to, tokenId);
1509         }
1510     }
1511 
1512     /**
1513      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1514      * @param to address representing the new owner of the given token ID
1515      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1516      */
1517     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1518         uint256 length = ERC721.balanceOf(to);
1519         _ownedTokens[to][length] = tokenId;
1520         _ownedTokensIndex[tokenId] = length;
1521     }
1522 
1523     /**
1524      * @dev Private function to add a token to this extension's token tracking data structures.
1525      * @param tokenId uint256 ID of the token to be added to the tokens list
1526      */
1527     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1528         _allTokensIndex[tokenId] = _allTokens.length;
1529         _allTokens.push(tokenId);
1530     }
1531 
1532     /**
1533      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1534      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1535      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1536      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1537      * @param from address representing the previous owner of the given token ID
1538      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1539      */
1540     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1541         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1542         // then delete the last slot (swap and pop).
1543 
1544         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1545         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1546 
1547         // When the token to delete is the last token, the swap operation is unnecessary
1548         if (tokenIndex != lastTokenIndex) {
1549             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1550 
1551             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1552             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1553         }
1554 
1555         // This also deletes the contents at the last position of the array
1556         delete _ownedTokensIndex[tokenId];
1557         delete _ownedTokens[from][lastTokenIndex];
1558     }
1559 
1560     /**
1561      * @dev Private function to remove a token from this extension's token tracking data structures.
1562      * This has O(1) time complexity, but alters the order of the _allTokens array.
1563      * @param tokenId uint256 ID of the token to be removed from the tokens list
1564      */
1565     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1566         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1567         // then delete the last slot (swap and pop).
1568 
1569         uint256 lastTokenIndex = _allTokens.length - 1;
1570         uint256 tokenIndex = _allTokensIndex[tokenId];
1571 
1572         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1573         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1574         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1575         uint256 lastTokenId = _allTokens[lastTokenIndex];
1576 
1577         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1578         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1579 
1580         // This also deletes the contents at the last position of the array
1581         delete _allTokensIndex[tokenId];
1582         _allTokens.pop();
1583     }
1584 }
1585 
1586 
1587 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1588 /**
1589  * @dev Contract module which allows children to implement an emergency stop
1590  * mechanism that can be triggered by an authorized account.
1591  *
1592  * This module is used through inheritance. It will make available the
1593  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1594  * the functions of your contract. Note that they will not be pausable by
1595  * simply including this module, only once the modifiers are put in place.
1596  */
1597 abstract contract Pausable is Context {
1598     /**
1599      * @dev Emitted when the pause is triggered by `account`.
1600      */
1601     event Paused(address account);
1602 
1603     /**
1604      * @dev Emitted when the pause is lifted by `account`.
1605      */
1606     event Unpaused(address account);
1607 
1608     bool private _paused;
1609 
1610     /**
1611      * @dev Initializes the contract in unpaused state.
1612      */
1613     constructor() {
1614         _paused = false;
1615     }
1616 
1617     /**
1618      * @dev Modifier to make a function callable only when the contract is not paused.
1619      *
1620      * Requirements:
1621      *
1622      * - The contract must not be paused.
1623      */
1624     modifier whenNotPaused() {
1625         _requireNotPaused();
1626         _;
1627     }
1628 
1629     /**
1630      * @dev Modifier to make a function callable only when the contract is paused.
1631      *
1632      * Requirements:
1633      *
1634      * - The contract must be paused.
1635      */
1636     modifier whenPaused() {
1637         _requirePaused();
1638         _;
1639     }
1640 
1641     /**
1642      * @dev Returns true if the contract is paused, and false otherwise.
1643      */
1644     function paused() public view virtual returns (bool) {
1645         return _paused;
1646     }
1647 
1648     /**
1649      * @dev Throws if the contract is paused.
1650      */
1651     function _requireNotPaused() internal view virtual {
1652         require(!paused(), "Pausable: paused");
1653     }
1654 
1655     /**
1656      * @dev Throws if the contract is not paused.
1657      */
1658     function _requirePaused() internal view virtual {
1659         require(paused(), "Pausable: not paused");
1660     }
1661 
1662     /**
1663      * @dev Triggers stopped state.
1664      *
1665      * Requirements:
1666      *
1667      * - The contract must not be paused.
1668      */
1669     function _pause() internal virtual whenNotPaused {
1670         _paused = true;
1671         emit Paused(_msgSender());
1672     }
1673 
1674     /**
1675      * @dev Returns to normal state.
1676      *
1677      * Requirements:
1678      *
1679      * - The contract must be paused.
1680      */
1681     function _unpause() internal virtual whenPaused {
1682         _paused = false;
1683         emit Unpaused(_msgSender());
1684     }
1685 }
1686 
1687 
1688 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1689 /**
1690  * @dev Contract module which provides a basic access control mechanism, where
1691  * there is an account (an owner) that can be granted exclusive access to
1692  * specific functions.
1693  *
1694  * By default, the owner account will be the one that deploys the contract. This
1695  * can later be changed with {transferOwnership}.
1696  *
1697  * This module is used through inheritance. It will make available the modifier
1698  * `onlyOwner`, which can be applied to your functions to restrict their use to
1699  * the owner.
1700  */
1701 abstract contract Ownable is Context {
1702     address private _owner;
1703 
1704     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1705 
1706     /**
1707      * @dev Initializes the contract setting the deployer as the initial owner.
1708      */
1709     constructor() {
1710         _transferOwnership(_msgSender());
1711     }
1712 
1713     /**
1714      * @dev Throws if called by any account other than the owner.
1715      */
1716     modifier onlyOwner() {
1717         _checkOwner();
1718         _;
1719     }
1720 
1721     /**
1722      * @dev Returns the address of the current owner.
1723      */
1724     function owner() public view virtual returns (address) {
1725         return _owner;
1726     }
1727 
1728     /**
1729      * @dev Throws if the sender is not the owner.
1730      */
1731     function _checkOwner() internal view virtual {
1732         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1733     }
1734 
1735     /**
1736      * @dev Leaves the contract without owner. It will not be possible to call
1737      * `onlyOwner` functions anymore. Can only be called by the current owner.
1738      *
1739      * NOTE: Renouncing ownership will leave the contract without an owner,
1740      * thereby removing any functionality that is only available to the owner.
1741      */
1742     function renounceOwnership() public virtual onlyOwner {
1743         _transferOwnership(address(0));
1744     }
1745 
1746     /**
1747      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1748      * Can only be called by the current owner.
1749      */
1750     function transferOwnership(address newOwner) public virtual onlyOwner {
1751         require(newOwner != address(0), "Ownable: new owner is the zero address");
1752         _transferOwnership(newOwner);
1753     }
1754 
1755     /**
1756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1757      * Internal function without access restriction.
1758      */
1759     function _transferOwnership(address newOwner) internal virtual {
1760         address oldOwner = _owner;
1761         _owner = newOwner;
1762         emit OwnershipTransferred(oldOwner, newOwner);
1763     }
1764 }
1765 
1766 
1767 /*
1768   beneath each ornate deception, a seed of fact takes root.
1769 */
1770 abstract contract DONOTMINT {
1771   function ownerOf(uint256 _tokenId) public view virtual returns (address);
1772 }
1773 
1774 contract HIDDEN is
1775   ERC721,
1776   ERC721Enumerable,
1777   Pausable,
1778   Ownable
1779 {
1780   mapping(uint256 => bool) public claimed;
1781   bool public claimOpen;
1782   string public baseTokenURI;
1783   DONOTMINT pillProvider;
1784 
1785   event PageClaimed(uint256 indexed id);
1786   constructor(address _pillProvider, string memory _baseUri)
1787   ERC721("HIDDEN CHAPTER", "PAGE") {
1788     setPillProvider(_pillProvider);
1789     setBaseURI(_baseUri);
1790     pause();
1791   }
1792 
1793   function claimOne(uint256 tokenId)
1794   public {
1795     require(claimOpen == true,
1796       "Claim is not open.");
1797     require(claimed[tokenId] != true,
1798       "Token already claimed.");
1799     require(msg.sender == pillProvider.ownerOf(tokenId),
1800       "You are not the owner of the token you are trying to use.");
1801     claimed[tokenId] = true;
1802     _safeMint(msg.sender, tokenId);
1803     emit PageClaimed(tokenId);
1804   }
1805 
1806   function claimAll(uint256[] memory tokenIds)
1807   public {
1808     for (uint256 i = 0; i < tokenIds.length; i++) {
1809       if (claimed[tokenIds[i]] == false) {
1810         claimOne(tokenIds[i]);
1811       }
1812     }
1813   }
1814 
1815   function setPillProvider(address _pillProvider)
1816   public
1817   onlyOwner {
1818     pillProvider = DONOTMINT(_pillProvider);
1819   }
1820 
1821   function setBaseURI(string memory _baseTokenURI)
1822   public
1823   onlyOwner {
1824     baseTokenURI = _baseTokenURI;
1825   }
1826 
1827   function openClaim()
1828   public
1829   onlyOwner {
1830     claimOpen = true;
1831   }
1832 
1833   function closeClaim()
1834   public
1835   onlyOwner {
1836     claimOpen = false;
1837   }
1838 
1839   function pause()
1840   public
1841   onlyOwner {
1842     _pause();
1843   }
1844 
1845   function unpause()
1846   public
1847   onlyOwner {
1848     _unpause();
1849   }
1850 
1851   function _baseURI()
1852   internal
1853   view
1854   override
1855   returns (string memory) {
1856     return baseTokenURI;
1857   }
1858 
1859   function _beforeTokenTransfer(
1860     address from,
1861     address to,
1862     uint256 tokenId,
1863     uint256 batchSize
1864   )
1865   internal
1866   whenNotPaused
1867   override(ERC721, ERC721Enumerable) {
1868     super._beforeTokenTransfer(from, to, tokenId, batchSize);
1869   }
1870 
1871   function supportsInterface(bytes4 interfaceId)
1872   public
1873   view
1874   override(ERC721, ERC721Enumerable)
1875   returns(bool) {
1876     return super.supportsInterface(interfaceId);
1877   }
1878 }