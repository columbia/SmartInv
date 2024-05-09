1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(
158         address target,
159         bytes memory data,
160         string memory errorMessage
161     ) internal view returns (bytes memory) {
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
193      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
194      *
195      * _Available since v4.8._
196      */
197     function verifyCallResultFromTarget(
198         address target,
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal view returns (bytes memory) {
203         if (success) {
204             if (returndata.length == 0) {
205                 // only check isContract if the call was successful and the return data is empty
206                 // otherwise we already know that it was a contract
207                 require(isContract(target), "Address: call to non-contract");
208             }
209             return returndata;
210         } else {
211             _revert(returndata, errorMessage);
212         }
213     }
214 
215     /**
216      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
217      * revert reason or using the provided one.
218      *
219      * _Available since v4.3._
220      */
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             _revert(returndata, errorMessage);
230         }
231     }
232 
233     function _revert(bytes memory returndata, string memory errorMessage) private pure {
234         // Look for revert reason and bubble it up if present
235         if (returndata.length > 0) {
236             // The easiest way to bubble the revert reason is using memory via assembly
237             /// @solidity memory-safe-assembly
238             assembly {
239                 let returndata_size := mload(returndata)
240                 revert(add(32, returndata), returndata_size)
241             }
242         } else {
243             revert(errorMessage);
244         }
245     }
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @title ERC721 token receiver interface
257  * @dev Interface for any contract that wants to support safeTransfers
258  * from ERC721 asset contracts.
259  */
260 interface IERC721Receiver {
261     /**
262      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
263      * by `operator` from `from`, this function is called.
264      *
265      * It must return its Solidity selector to confirm the token transfer.
266      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
267      *
268      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
269      */
270     function onERC721Received(
271         address operator,
272         address from,
273         uint256 tokenId,
274         bytes calldata data
275     ) external returns (bytes4);
276 }
277 
278 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Interface of the ERC165 standard, as defined in the
287  * https://eips.ethereum.org/EIPS/eip-165[EIP].
288  *
289  * Implementers can declare support of contract interfaces, which can then be
290  * queried by others ({ERC165Checker}).
291  *
292  * For an implementation, see {ERC165}.
293  */
294 interface IERC165 {
295     /**
296      * @dev Returns true if this contract implements the interface defined by
297      * `interfaceId`. See the corresponding
298      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
299      * to learn more about how these ids are created.
300      *
301      * This function call must use less than 30 000 gas.
302      */
303     function supportsInterface(bytes4 interfaceId) external view returns (bool);
304 }
305 
306 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 
314 /**
315  * @dev Implementation of the {IERC165} interface.
316  *
317  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
318  * for the additional interface id that will be supported. For example:
319  *
320  * ```solidity
321  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
322  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
323  * }
324  * ```
325  *
326  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
327  */
328 abstract contract ERC165 is IERC165 {
329     /**
330      * @dev See {IERC165-supportsInterface}.
331      */
332     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
333         return interfaceId == type(IERC165).interfaceId;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
338 
339 
340 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 
345 /**
346  * @dev Required interface of an ERC721 compliant contract.
347  */
348 interface IERC721 is IERC165 {
349     /**
350      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
351      */
352     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
353 
354     /**
355      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
356      */
357     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
358 
359     /**
360      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
361      */
362     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
363 
364     /**
365      * @dev Returns the number of tokens in ``owner``'s account.
366      */
367     function balanceOf(address owner) external view returns (uint256 balance);
368 
369     /**
370      * @dev Returns the owner of the `tokenId` token.
371      *
372      * Requirements:
373      *
374      * - `tokenId` must exist.
375      */
376     function ownerOf(uint256 tokenId) external view returns (address owner);
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must exist and be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
388      *
389      * Emits a {Transfer} event.
390      */
391     function safeTransferFrom(
392         address from,
393         address to,
394         uint256 tokenId,
395         bytes calldata data
396     ) external;
397 
398     /**
399      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
400      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
401      *
402      * Requirements:
403      *
404      * - `from` cannot be the zero address.
405      * - `to` cannot be the zero address.
406      * - `tokenId` token must exist and be owned by `from`.
407      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
408      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
409      *
410      * Emits a {Transfer} event.
411      */
412     function safeTransferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Transfers `tokenId` token from `from` to `to`.
420      *
421      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
422      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
423      * understand this adds an external call which potentially creates a reentrancy vulnerability.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must be owned by `from`.
430      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
445      *
446      * Requirements:
447      *
448      * - The caller must own the token or be an approved operator.
449      * - `tokenId` must exist.
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address to, uint256 tokenId) external;
454 
455     /**
456      * @dev Approve or remove `operator` as an operator for the caller.
457      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
458      *
459      * Requirements:
460      *
461      * - The `operator` cannot be the caller.
462      *
463      * Emits an {ApprovalForAll} event.
464      */
465     function setApprovalForAll(address operator, bool _approved) external;
466 
467     /**
468      * @dev Returns the account approved for `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function getApproved(uint256 tokenId) external view returns (address operator);
475 
476     /**
477      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
478      *
479      * See {setApprovalForAll}
480      */
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
494  * @dev See https://eips.ethereum.org/EIPS/eip-721
495  */
496 interface IERC721Metadata is IERC721 {
497     /**
498      * @dev Returns the token collection name.
499      */
500     function name() external view returns (string memory);
501 
502     /**
503      * @dev Returns the token collection symbol.
504      */
505     function symbol() external view returns (string memory);
506 
507     /**
508      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
509      */
510     function tokenURI(uint256 tokenId) external view returns (string memory);
511 }
512 
513 // File: @openzeppelin/contracts/utils/Counters.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @title Counters
522  * @author Matt Condon (@shrugs)
523  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
524  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
525  *
526  * Include with `using Counters for Counters.Counter;`
527  */
528 library Counters {
529     struct Counter {
530         // This variable should never be directly accessed by users of the library: interactions must be restricted to
531         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
532         // this feature: see https://github.com/ethereum/solidity/issues/4637
533         uint256 _value; // default: 0
534     }
535 
536     function current(Counter storage counter) internal view returns (uint256) {
537         return counter._value;
538     }
539 
540     function increment(Counter storage counter) internal {
541         unchecked {
542             counter._value += 1;
543         }
544     }
545 
546     function decrement(Counter storage counter) internal {
547         uint256 value = counter._value;
548         require(value > 0, "Counter: decrement overflow");
549         unchecked {
550             counter._value = value - 1;
551         }
552     }
553 
554     function reset(Counter storage counter) internal {
555         counter._value = 0;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/math/Math.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Standard math utilities missing in the Solidity language.
568  */
569 library Math {
570     enum Rounding {
571         Down, // Toward negative infinity
572         Up, // Toward infinity
573         Zero // Toward zero
574     }
575 
576     /**
577      * @dev Returns the largest of two numbers.
578      */
579     function max(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a > b ? a : b;
581     }
582 
583     /**
584      * @dev Returns the smallest of two numbers.
585      */
586     function min(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a < b ? a : b;
588     }
589 
590     /**
591      * @dev Returns the average of two numbers. The result is rounded towards
592      * zero.
593      */
594     function average(uint256 a, uint256 b) internal pure returns (uint256) {
595         // (a + b) / 2 can overflow.
596         return (a & b) + (a ^ b) / 2;
597     }
598 
599     /**
600      * @dev Returns the ceiling of the division of two numbers.
601      *
602      * This differs from standard division with `/` in that it rounds up instead
603      * of rounding down.
604      */
605     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
606         // (a + b - 1) / b can overflow on addition, so we distribute.
607         return a == 0 ? 0 : (a - 1) / b + 1;
608     }
609 
610     /**
611      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
612      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
613      * with further edits by Uniswap Labs also under MIT license.
614      */
615     function mulDiv(
616         uint256 x,
617         uint256 y,
618         uint256 denominator
619     ) internal pure returns (uint256 result) {
620         unchecked {
621             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
622             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
623             // variables such that product = prod1 * 2^256 + prod0.
624             uint256 prod0; // Least significant 256 bits of the product
625             uint256 prod1; // Most significant 256 bits of the product
626             assembly {
627                 let mm := mulmod(x, y, not(0))
628                 prod0 := mul(x, y)
629                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
630             }
631 
632             // Handle non-overflow cases, 256 by 256 division.
633             if (prod1 == 0) {
634                 return prod0 / denominator;
635             }
636 
637             // Make sure the result is less than 2^256. Also prevents denominator == 0.
638             require(denominator > prod1);
639 
640             ///////////////////////////////////////////////
641             // 512 by 256 division.
642             ///////////////////////////////////////////////
643 
644             // Make division exact by subtracting the remainder from [prod1 prod0].
645             uint256 remainder;
646             assembly {
647                 // Compute remainder using mulmod.
648                 remainder := mulmod(x, y, denominator)
649 
650                 // Subtract 256 bit number from 512 bit number.
651                 prod1 := sub(prod1, gt(remainder, prod0))
652                 prod0 := sub(prod0, remainder)
653             }
654 
655             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
656             // See https://cs.stackexchange.com/q/138556/92363.
657 
658             // Does not overflow because the denominator cannot be zero at this stage in the function.
659             uint256 twos = denominator & (~denominator + 1);
660             assembly {
661                 // Divide denominator by twos.
662                 denominator := div(denominator, twos)
663 
664                 // Divide [prod1 prod0] by twos.
665                 prod0 := div(prod0, twos)
666 
667                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
668                 twos := add(div(sub(0, twos), twos), 1)
669             }
670 
671             // Shift in bits from prod1 into prod0.
672             prod0 |= prod1 * twos;
673 
674             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
675             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
676             // four bits. That is, denominator * inv = 1 mod 2^4.
677             uint256 inverse = (3 * denominator) ^ 2;
678 
679             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
680             // in modular arithmetic, doubling the correct bits in each step.
681             inverse *= 2 - denominator * inverse; // inverse mod 2^8
682             inverse *= 2 - denominator * inverse; // inverse mod 2^16
683             inverse *= 2 - denominator * inverse; // inverse mod 2^32
684             inverse *= 2 - denominator * inverse; // inverse mod 2^64
685             inverse *= 2 - denominator * inverse; // inverse mod 2^128
686             inverse *= 2 - denominator * inverse; // inverse mod 2^256
687 
688             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
689             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
690             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
691             // is no longer required.
692             result = prod0 * inverse;
693             return result;
694         }
695     }
696 
697     /**
698      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
699      */
700     function mulDiv(
701         uint256 x,
702         uint256 y,
703         uint256 denominator,
704         Rounding rounding
705     ) internal pure returns (uint256) {
706         uint256 result = mulDiv(x, y, denominator);
707         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
708             result += 1;
709         }
710         return result;
711     }
712 
713     /**
714      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
715      *
716      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
717      */
718     function sqrt(uint256 a) internal pure returns (uint256) {
719         if (a == 0) {
720             return 0;
721         }
722 
723         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
724         //
725         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
726         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
727         //
728         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
729         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
730         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
731         //
732         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
733         uint256 result = 1 << (log2(a) >> 1);
734 
735         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
736         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
737         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
738         // into the expected uint128 result.
739         unchecked {
740             result = (result + a / result) >> 1;
741             result = (result + a / result) >> 1;
742             result = (result + a / result) >> 1;
743             result = (result + a / result) >> 1;
744             result = (result + a / result) >> 1;
745             result = (result + a / result) >> 1;
746             result = (result + a / result) >> 1;
747             return min(result, a / result);
748         }
749     }
750 
751     /**
752      * @notice Calculates sqrt(a), following the selected rounding direction.
753      */
754     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
755         unchecked {
756             uint256 result = sqrt(a);
757             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
758         }
759     }
760 
761     /**
762      * @dev Return the log in base 2, rounded down, of a positive value.
763      * Returns 0 if given 0.
764      */
765     function log2(uint256 value) internal pure returns (uint256) {
766         uint256 result = 0;
767         unchecked {
768             if (value >> 128 > 0) {
769                 value >>= 128;
770                 result += 128;
771             }
772             if (value >> 64 > 0) {
773                 value >>= 64;
774                 result += 64;
775             }
776             if (value >> 32 > 0) {
777                 value >>= 32;
778                 result += 32;
779             }
780             if (value >> 16 > 0) {
781                 value >>= 16;
782                 result += 16;
783             }
784             if (value >> 8 > 0) {
785                 value >>= 8;
786                 result += 8;
787             }
788             if (value >> 4 > 0) {
789                 value >>= 4;
790                 result += 4;
791             }
792             if (value >> 2 > 0) {
793                 value >>= 2;
794                 result += 2;
795             }
796             if (value >> 1 > 0) {
797                 result += 1;
798             }
799         }
800         return result;
801     }
802 
803     /**
804      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
805      * Returns 0 if given 0.
806      */
807     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
808         unchecked {
809             uint256 result = log2(value);
810             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
811         }
812     }
813 
814     /**
815      * @dev Return the log in base 10, rounded down, of a positive value.
816      * Returns 0 if given 0.
817      */
818     function log10(uint256 value) internal pure returns (uint256) {
819         uint256 result = 0;
820         unchecked {
821             if (value >= 10**64) {
822                 value /= 10**64;
823                 result += 64;
824             }
825             if (value >= 10**32) {
826                 value /= 10**32;
827                 result += 32;
828             }
829             if (value >= 10**16) {
830                 value /= 10**16;
831                 result += 16;
832             }
833             if (value >= 10**8) {
834                 value /= 10**8;
835                 result += 8;
836             }
837             if (value >= 10**4) {
838                 value /= 10**4;
839                 result += 4;
840             }
841             if (value >= 10**2) {
842                 value /= 10**2;
843                 result += 2;
844             }
845             if (value >= 10**1) {
846                 result += 1;
847             }
848         }
849         return result;
850     }
851 
852     /**
853      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
854      * Returns 0 if given 0.
855      */
856     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
857         unchecked {
858             uint256 result = log10(value);
859             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
860         }
861     }
862 
863     /**
864      * @dev Return the log in base 256, rounded down, of a positive value.
865      * Returns 0 if given 0.
866      *
867      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
868      */
869     function log256(uint256 value) internal pure returns (uint256) {
870         uint256 result = 0;
871         unchecked {
872             if (value >> 128 > 0) {
873                 value >>= 128;
874                 result += 16;
875             }
876             if (value >> 64 > 0) {
877                 value >>= 64;
878                 result += 8;
879             }
880             if (value >> 32 > 0) {
881                 value >>= 32;
882                 result += 4;
883             }
884             if (value >> 16 > 0) {
885                 value >>= 16;
886                 result += 2;
887             }
888             if (value >> 8 > 0) {
889                 result += 1;
890             }
891         }
892         return result;
893     }
894 
895     /**
896      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
897      * Returns 0 if given 0.
898      */
899     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
900         unchecked {
901             uint256 result = log256(value);
902             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
903         }
904     }
905 }
906 
907 // File: @openzeppelin/contracts/utils/Strings.sol
908 
909 
910 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @dev String operations.
917  */
918 library Strings {
919     bytes16 private constant _SYMBOLS = "0123456789abcdef";
920     uint8 private constant _ADDRESS_LENGTH = 20;
921 
922     /**
923      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
924      */
925     function toString(uint256 value) internal pure returns (string memory) {
926         unchecked {
927             uint256 length = Math.log10(value) + 1;
928             string memory buffer = new string(length);
929             uint256 ptr;
930             /// @solidity memory-safe-assembly
931             assembly {
932                 ptr := add(buffer, add(32, length))
933             }
934             while (true) {
935                 ptr--;
936                 /// @solidity memory-safe-assembly
937                 assembly {
938                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
939                 }
940                 value /= 10;
941                 if (value == 0) break;
942             }
943             return buffer;
944         }
945     }
946 
947     /**
948      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
949      */
950     function toHexString(uint256 value) internal pure returns (string memory) {
951         unchecked {
952             return toHexString(value, Math.log256(value) + 1);
953         }
954     }
955 
956     /**
957      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
958      */
959     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
960         bytes memory buffer = new bytes(2 * length + 2);
961         buffer[0] = "0";
962         buffer[1] = "x";
963         for (uint256 i = 2 * length + 1; i > 1; --i) {
964             buffer[i] = _SYMBOLS[value & 0xf];
965             value >>= 4;
966         }
967         require(value == 0, "Strings: hex length insufficient");
968         return string(buffer);
969     }
970 
971     /**
972      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
973      */
974     function toHexString(address addr) internal pure returns (string memory) {
975         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
976     }
977 }
978 
979 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
980 
981 
982 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 
987 /**
988  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
989  *
990  * These functions can be used to verify that a message was signed by the holder
991  * of the private keys of a given address.
992  */
993 library ECDSA {
994     enum RecoverError {
995         NoError,
996         InvalidSignature,
997         InvalidSignatureLength,
998         InvalidSignatureS,
999         InvalidSignatureV // Deprecated in v4.8
1000     }
1001 
1002     function _throwError(RecoverError error) private pure {
1003         if (error == RecoverError.NoError) {
1004             return; // no error: do nothing
1005         } else if (error == RecoverError.InvalidSignature) {
1006             revert("ECDSA: invalid signature");
1007         } else if (error == RecoverError.InvalidSignatureLength) {
1008             revert("ECDSA: invalid signature length");
1009         } else if (error == RecoverError.InvalidSignatureS) {
1010             revert("ECDSA: invalid signature 's' value");
1011         }
1012     }
1013 
1014     /**
1015      * @dev Returns the address that signed a hashed message (`hash`) with
1016      * `signature` or error string. This address can then be used for verification purposes.
1017      *
1018      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1019      * this function rejects them by requiring the `s` value to be in the lower
1020      * half order, and the `v` value to be either 27 or 28.
1021      *
1022      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1023      * verification to be secure: it is possible to craft signatures that
1024      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1025      * this is by receiving a hash of the original message (which may otherwise
1026      * be too long), and then calling {toEthSignedMessageHash} on it.
1027      *
1028      * Documentation for signature generation:
1029      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1030      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1031      *
1032      * _Available since v4.3._
1033      */
1034     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1035         if (signature.length == 65) {
1036             bytes32 r;
1037             bytes32 s;
1038             uint8 v;
1039             // ecrecover takes the signature parameters, and the only way to get them
1040             // currently is to use assembly.
1041             /// @solidity memory-safe-assembly
1042             assembly {
1043                 r := mload(add(signature, 0x20))
1044                 s := mload(add(signature, 0x40))
1045                 v := byte(0, mload(add(signature, 0x60)))
1046             }
1047             return tryRecover(hash, v, r, s);
1048         } else {
1049             return (address(0), RecoverError.InvalidSignatureLength);
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns the address that signed a hashed message (`hash`) with
1055      * `signature`. This address can then be used for verification purposes.
1056      *
1057      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1058      * this function rejects them by requiring the `s` value to be in the lower
1059      * half order, and the `v` value to be either 27 or 28.
1060      *
1061      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1062      * verification to be secure: it is possible to craft signatures that
1063      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1064      * this is by receiving a hash of the original message (which may otherwise
1065      * be too long), and then calling {toEthSignedMessageHash} on it.
1066      */
1067     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1068         (address recovered, RecoverError error) = tryRecover(hash, signature);
1069         _throwError(error);
1070         return recovered;
1071     }
1072 
1073     /**
1074      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1075      *
1076      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1077      *
1078      * _Available since v4.3._
1079      */
1080     function tryRecover(
1081         bytes32 hash,
1082         bytes32 r,
1083         bytes32 vs
1084     ) internal pure returns (address, RecoverError) {
1085         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1086         uint8 v = uint8((uint256(vs) >> 255) + 27);
1087         return tryRecover(hash, v, r, s);
1088     }
1089 
1090     /**
1091      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1092      *
1093      * _Available since v4.2._
1094      */
1095     function recover(
1096         bytes32 hash,
1097         bytes32 r,
1098         bytes32 vs
1099     ) internal pure returns (address) {
1100         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1101         _throwError(error);
1102         return recovered;
1103     }
1104 
1105     /**
1106      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1107      * `r` and `s` signature fields separately.
1108      *
1109      * _Available since v4.3._
1110      */
1111     function tryRecover(
1112         bytes32 hash,
1113         uint8 v,
1114         bytes32 r,
1115         bytes32 s
1116     ) internal pure returns (address, RecoverError) {
1117         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1118         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1119         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1120         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1121         //
1122         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1123         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1124         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1125         // these malleable signatures as well.
1126         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1127             return (address(0), RecoverError.InvalidSignatureS);
1128         }
1129 
1130         // If the signature is valid (and not malleable), return the signer address
1131         address signer = ecrecover(hash, v, r, s);
1132         if (signer == address(0)) {
1133             return (address(0), RecoverError.InvalidSignature);
1134         }
1135 
1136         return (signer, RecoverError.NoError);
1137     }
1138 
1139     /**
1140      * @dev Overload of {ECDSA-recover} that receives the `v`,
1141      * `r` and `s` signature fields separately.
1142      */
1143     function recover(
1144         bytes32 hash,
1145         uint8 v,
1146         bytes32 r,
1147         bytes32 s
1148     ) internal pure returns (address) {
1149         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1150         _throwError(error);
1151         return recovered;
1152     }
1153 
1154     /**
1155      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1156      * produces hash corresponding to the one signed with the
1157      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1158      * JSON-RPC method as part of EIP-191.
1159      *
1160      * See {recover}.
1161      */
1162     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1163         // 32 is the length in bytes of hash,
1164         // enforced by the type signature above
1165         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1166     }
1167 
1168     /**
1169      * @dev Returns an Ethereum Signed Message, created from `s`. This
1170      * produces hash corresponding to the one signed with the
1171      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1172      * JSON-RPC method as part of EIP-191.
1173      *
1174      * See {recover}.
1175      */
1176     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1177         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1178     }
1179 
1180     /**
1181      * @dev Returns an Ethereum Signed Typed Data, created from a
1182      * `domainSeparator` and a `structHash`. This produces hash corresponding
1183      * to the one signed with the
1184      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1185      * JSON-RPC method as part of EIP-712.
1186      *
1187      * See {recover}.
1188      */
1189     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1190         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1191     }
1192 }
1193 
1194 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
1195 
1196 
1197 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 
1202 /**
1203  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1204  *
1205  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1206  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1207  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1208  *
1209  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1210  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1211  * ({_hashTypedDataV4}).
1212  *
1213  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1214  * the chain id to protect against replay attacks on an eventual fork of the chain.
1215  *
1216  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1217  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1218  *
1219  * _Available since v3.4._
1220  */
1221 abstract contract EIP712 {
1222     /* solhint-disable var-name-mixedcase */
1223     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1224     // invalidate the cached domain separator if the chain id changes.
1225     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1226     uint256 private immutable _CACHED_CHAIN_ID;
1227     address private immutable _CACHED_THIS;
1228 
1229     bytes32 private immutable _HASHED_NAME;
1230     bytes32 private immutable _HASHED_VERSION;
1231     bytes32 private immutable _TYPE_HASH;
1232 
1233     /* solhint-enable var-name-mixedcase */
1234 
1235     /**
1236      * @dev Initializes the domain separator and parameter caches.
1237      *
1238      * The meaning of `name` and `version` is specified in
1239      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1240      *
1241      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1242      * - `version`: the current major version of the signing domain.
1243      *
1244      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1245      * contract upgrade].
1246      */
1247     constructor(string memory name, string memory version) {
1248         bytes32 hashedName = keccak256(bytes(name));
1249         bytes32 hashedVersion = keccak256(bytes(version));
1250         bytes32 typeHash = keccak256(
1251             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1252         );
1253         _HASHED_NAME = hashedName;
1254         _HASHED_VERSION = hashedVersion;
1255         _CACHED_CHAIN_ID = block.chainid;
1256         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1257         _CACHED_THIS = address(this);
1258         _TYPE_HASH = typeHash;
1259     }
1260 
1261     /**
1262      * @dev Returns the domain separator for the current chain.
1263      */
1264     function _domainSeparatorV4() internal view returns (bytes32) {
1265         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1266             return _CACHED_DOMAIN_SEPARATOR;
1267         } else {
1268             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1269         }
1270     }
1271 
1272     function _buildDomainSeparator(
1273         bytes32 typeHash,
1274         bytes32 nameHash,
1275         bytes32 versionHash
1276     ) private view returns (bytes32) {
1277         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1278     }
1279 
1280     /**
1281      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1282      * function returns the hash of the fully encoded EIP712 message for this domain.
1283      *
1284      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1285      *
1286      * ```solidity
1287      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1288      *     keccak256("Mail(address to,string contents)"),
1289      *     mailTo,
1290      *     keccak256(bytes(mailContents))
1291      * )));
1292      * address signer = ECDSA.recover(digest, signature);
1293      * ```
1294      */
1295     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1296         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1297     }
1298 }
1299 
1300 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1301 
1302 
1303 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/draft-EIP712.sol)
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 // EIP-712 is Final as of 2022-08-11. This file is deprecated.
1308 
1309 
1310 // File: @openzeppelin/contracts/utils/Context.sol
1311 
1312 
1313 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 /**
1318  * @dev Provides information about the current execution context, including the
1319  * sender of the transaction and its data. While these are generally available
1320  * via msg.sender and msg.data, they should not be accessed in such a direct
1321  * manner, since when dealing with meta-transactions the account sending and
1322  * paying for execution may not be the actual sender (as far as an application
1323  * is concerned).
1324  *
1325  * This contract is only required for intermediate, library-like contracts.
1326  */
1327 abstract contract Context {
1328     function _msgSender() internal view virtual returns (address) {
1329         return msg.sender;
1330     }
1331 
1332     function _msgData() internal view virtual returns (bytes calldata) {
1333         return msg.data;
1334     }
1335 }
1336 
1337 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1338 
1339 
1340 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1341 
1342 pragma solidity ^0.8.0;
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 
1351 /**
1352  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1353  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1354  * {ERC721Enumerable}.
1355  */
1356 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1357     using Address for address;
1358     using Strings for uint256;
1359 
1360     // Token name
1361     string private _name;
1362 
1363     // Token symbol
1364     string private _symbol;
1365 
1366     // Mapping from token ID to owner address
1367     mapping(uint256 => address) private _owners;
1368 
1369     // Mapping owner address to token count
1370     mapping(address => uint256) private _balances;
1371 
1372     // Mapping from token ID to approved address
1373     mapping(uint256 => address) private _tokenApprovals;
1374 
1375     // Mapping from owner to operator approvals
1376     mapping(address => mapping(address => bool)) private _operatorApprovals;
1377 
1378     /**
1379      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1380      */
1381     constructor(string memory name_, string memory symbol_) {
1382         _name = name_;
1383         _symbol = symbol_;
1384     }
1385 
1386     /**
1387      * @dev See {IERC165-supportsInterface}.
1388      */
1389     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1390         return
1391             interfaceId == type(IERC721).interfaceId ||
1392             interfaceId == type(IERC721Metadata).interfaceId ||
1393             super.supportsInterface(interfaceId);
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-balanceOf}.
1398      */
1399     function balanceOf(address owner) public view virtual override returns (uint256) {
1400         require(owner != address(0), "ERC721: address zero is not a valid owner");
1401         return _balances[owner];
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-ownerOf}.
1406      */
1407     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1408         address owner = _ownerOf(tokenId);
1409         require(owner != address(0), "ERC721: invalid token ID");
1410         return owner;
1411     }
1412 
1413     /**
1414      * @dev See {IERC721Metadata-name}.
1415      */
1416     function name() public view virtual override returns (string memory) {
1417         return _name;
1418     }
1419 
1420     /**
1421      * @dev See {IERC721Metadata-symbol}.
1422      */
1423     function symbol() public view virtual override returns (string memory) {
1424         return _symbol;
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Metadata-tokenURI}.
1429      */
1430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1431         _requireMinted(tokenId);
1432 
1433         string memory baseURI = _baseURI();
1434         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1435     }
1436 
1437     /**
1438      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1439      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1440      * by default, can be overridden in child contracts.
1441      */
1442     function _baseURI() internal view virtual returns (string memory) {
1443         return "";
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-approve}.
1448      */
1449     function approve(address to, uint256 tokenId) public virtual override {
1450         address owner = ERC721.ownerOf(tokenId);
1451         require(to != owner, "ERC721: approval to current owner");
1452 
1453         require(
1454             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1455             "ERC721: approve caller is not token owner or approved for all"
1456         );
1457 
1458         _approve(to, tokenId);
1459     }
1460 
1461     /**
1462      * @dev See {IERC721-getApproved}.
1463      */
1464     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1465         _requireMinted(tokenId);
1466 
1467         return _tokenApprovals[tokenId];
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-setApprovalForAll}.
1472      */
1473     function setApprovalForAll(address operator, bool approved) public virtual override {
1474         _setApprovalForAll(_msgSender(), operator, approved);
1475     }
1476 
1477     /**
1478      * @dev See {IERC721-isApprovedForAll}.
1479      */
1480     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1481         return _operatorApprovals[owner][operator];
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-transferFrom}.
1486      */
1487     function transferFrom(
1488         address from,
1489         address to,
1490         uint256 tokenId
1491     ) public virtual override {
1492         //solhint-disable-next-line max-line-length
1493         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1494 
1495         _transfer(from, to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-safeTransferFrom}.
1500      */
1501     function safeTransferFrom(
1502         address from,
1503         address to,
1504         uint256 tokenId
1505     ) public virtual override {
1506         safeTransferFrom(from, to, tokenId, "");
1507     }
1508 
1509     /**
1510      * @dev See {IERC721-safeTransferFrom}.
1511      */
1512     function safeTransferFrom(
1513         address from,
1514         address to,
1515         uint256 tokenId,
1516         bytes memory data
1517     ) public virtual override {
1518         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1519         _safeTransfer(from, to, tokenId, data);
1520     }
1521 
1522     /**
1523      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1524      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1525      *
1526      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1527      *
1528      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1529      * implement alternative mechanisms to perform token transfer, such as signature-based.
1530      *
1531      * Requirements:
1532      *
1533      * - `from` cannot be the zero address.
1534      * - `to` cannot be the zero address.
1535      * - `tokenId` token must exist and be owned by `from`.
1536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1537      *
1538      * Emits a {Transfer} event.
1539      */
1540     function _safeTransfer(
1541         address from,
1542         address to,
1543         uint256 tokenId,
1544         bytes memory data
1545     ) internal virtual {
1546         _transfer(from, to, tokenId);
1547         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1548     }
1549 
1550     /**
1551      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1552      */
1553     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1554         return _owners[tokenId];
1555     }
1556 
1557     /**
1558      * @dev Returns whether `tokenId` exists.
1559      *
1560      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1561      *
1562      * Tokens start existing when they are minted (`_mint`),
1563      * and stop existing when they are burned (`_burn`).
1564      */
1565     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1566         return _ownerOf(tokenId) != address(0);
1567     }
1568 
1569     /**
1570      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1571      *
1572      * Requirements:
1573      *
1574      * - `tokenId` must exist.
1575      */
1576     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1577         address owner = ERC721.ownerOf(tokenId);
1578         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1579     }
1580 
1581     /**
1582      * @dev Safely mints `tokenId` and transfers it to `to`.
1583      *
1584      * Requirements:
1585      *
1586      * - `tokenId` must not exist.
1587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1588      *
1589      * Emits a {Transfer} event.
1590      */
1591     function _safeMint(address to, uint256 tokenId) internal virtual {
1592         _safeMint(to, tokenId, "");
1593     }
1594 
1595     /**
1596      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1597      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1598      */
1599     function _safeMint(
1600         address to,
1601         uint256 tokenId,
1602         bytes memory data
1603     ) internal virtual {
1604         _mint(to, tokenId);
1605         require(
1606             _checkOnERC721Received(address(0), to, tokenId, data),
1607             "ERC721: transfer to non ERC721Receiver implementer"
1608         );
1609     }
1610 
1611     /**
1612      * @dev Mints `tokenId` and transfers it to `to`.
1613      *
1614      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must not exist.
1619      * - `to` cannot be the zero address.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function _mint(address to, uint256 tokenId) internal virtual {
1624         require(to != address(0), "ERC721: mint to the zero address");
1625         require(!_exists(tokenId), "ERC721: token already minted");
1626 
1627         _beforeTokenTransfer(address(0), to, tokenId, 1);
1628 
1629         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1630         require(!_exists(tokenId), "ERC721: token already minted");
1631 
1632         unchecked {
1633             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1634             // Given that tokens are minted one by one, it is impossible in practice that
1635             // this ever happens. Might change if we allow batch minting.
1636             // The ERC fails to describe this case.
1637             _balances[to] += 1;
1638         }
1639 
1640         _owners[tokenId] = to;
1641 
1642         emit Transfer(address(0), to, tokenId);
1643 
1644         _afterTokenTransfer(address(0), to, tokenId, 1);
1645     }
1646 
1647     /**
1648      * @dev Destroys `tokenId`.
1649      * The approval is cleared when the token is burned.
1650      * This is an internal function that does not check if the sender is authorized to operate on the token.
1651      *
1652      * Requirements:
1653      *
1654      * - `tokenId` must exist.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function _burn(uint256 tokenId) internal virtual {
1659         address owner = ERC721.ownerOf(tokenId);
1660 
1661         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1662 
1663         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1664         owner = ERC721.ownerOf(tokenId);
1665 
1666         // Clear approvals
1667         delete _tokenApprovals[tokenId];
1668 
1669         unchecked {
1670             // Cannot overflow, as that would require more tokens to be burned/transferred
1671             // out than the owner initially received through minting and transferring in.
1672             _balances[owner] -= 1;
1673         }
1674         delete _owners[tokenId];
1675 
1676         emit Transfer(owner, address(0), tokenId);
1677 
1678         _afterTokenTransfer(owner, address(0), tokenId, 1);
1679     }
1680 
1681     /**
1682      * @dev Transfers `tokenId` from `from` to `to`.
1683      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1684      *
1685      * Requirements:
1686      *
1687      * - `to` cannot be the zero address.
1688      * - `tokenId` token must be owned by `from`.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _transfer(
1693         address from,
1694         address to,
1695         uint256 tokenId
1696     ) internal virtual {
1697         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1698         require(to != address(0), "ERC721: transfer to the zero address");
1699 
1700         _beforeTokenTransfer(from, to, tokenId, 1);
1701 
1702         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1703         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1704 
1705         // Clear approvals from the previous owner
1706         delete _tokenApprovals[tokenId];
1707 
1708         unchecked {
1709             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1710             // `from`'s balance is the number of token held, which is at least one before the current
1711             // transfer.
1712             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1713             // all 2**256 token ids to be minted, which in practice is impossible.
1714             _balances[from] -= 1;
1715             _balances[to] += 1;
1716         }
1717         _owners[tokenId] = to;
1718 
1719         emit Transfer(from, to, tokenId);
1720 
1721         _afterTokenTransfer(from, to, tokenId, 1);
1722     }
1723 
1724     /**
1725      * @dev Approve `to` to operate on `tokenId`
1726      *
1727      * Emits an {Approval} event.
1728      */
1729     function _approve(address to, uint256 tokenId) internal virtual {
1730         _tokenApprovals[tokenId] = to;
1731         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1732     }
1733 
1734     /**
1735      * @dev Approve `operator` to operate on all of `owner` tokens
1736      *
1737      * Emits an {ApprovalForAll} event.
1738      */
1739     function _setApprovalForAll(
1740         address owner,
1741         address operator,
1742         bool approved
1743     ) internal virtual {
1744         require(owner != operator, "ERC721: approve to caller");
1745         _operatorApprovals[owner][operator] = approved;
1746         emit ApprovalForAll(owner, operator, approved);
1747     }
1748 
1749     /**
1750      * @dev Reverts if the `tokenId` has not been minted yet.
1751      */
1752     function _requireMinted(uint256 tokenId) internal view virtual {
1753         require(_exists(tokenId), "ERC721: invalid token ID");
1754     }
1755 
1756     /**
1757      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1758      * The call is not executed if the target address is not a contract.
1759      *
1760      * @param from address representing the previous owner of the given token ID
1761      * @param to target address that will receive the tokens
1762      * @param tokenId uint256 ID of the token to be transferred
1763      * @param data bytes optional data to send along with the call
1764      * @return bool whether the call correctly returned the expected magic value
1765      */
1766     function _checkOnERC721Received(
1767         address from,
1768         address to,
1769         uint256 tokenId,
1770         bytes memory data
1771     ) private returns (bool) {
1772         if (to.isContract()) {
1773             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1774                 return retval == IERC721Receiver.onERC721Received.selector;
1775             } catch (bytes memory reason) {
1776                 if (reason.length == 0) {
1777                     revert("ERC721: transfer to non ERC721Receiver implementer");
1778                 } else {
1779                     /// @solidity memory-safe-assembly
1780                     assembly {
1781                         revert(add(32, reason), mload(reason))
1782                     }
1783                 }
1784             }
1785         } else {
1786             return true;
1787         }
1788     }
1789 
1790     /**
1791      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1792      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1793      *
1794      * Calling conditions:
1795      *
1796      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1797      * - When `from` is zero, the tokens will be minted for `to`.
1798      * - When `to` is zero, ``from``'s tokens will be burned.
1799      * - `from` and `to` are never both zero.
1800      * - `batchSize` is non-zero.
1801      *
1802      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1803      */
1804     function _beforeTokenTransfer(
1805         address from,
1806         address to,
1807         uint256, /* firstTokenId */
1808         uint256 batchSize
1809     ) internal virtual {
1810         if (batchSize > 1) {
1811             if (from != address(0)) {
1812                 _balances[from] -= batchSize;
1813             }
1814             if (to != address(0)) {
1815                 _balances[to] += batchSize;
1816             }
1817         }
1818     }
1819 
1820     /**
1821      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1822      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1823      *
1824      * Calling conditions:
1825      *
1826      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1827      * - When `from` is zero, the tokens were minted for `to`.
1828      * - When `to` is zero, ``from``'s tokens were burned.
1829      * - `from` and `to` are never both zero.
1830      * - `batchSize` is non-zero.
1831      *
1832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1833      */
1834     function _afterTokenTransfer(
1835         address from,
1836         address to,
1837         uint256 firstTokenId,
1838         uint256 batchSize
1839     ) internal virtual {}
1840 }
1841 
1842 // File: @openzeppelin/contracts/access/Ownable.sol
1843 
1844 
1845 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1846 
1847 pragma solidity ^0.8.0;
1848 
1849 
1850 /**
1851  * @dev Contract module which provides a basic access control mechanism, where
1852  * there is an account (an owner) that can be granted exclusive access to
1853  * specific functions.
1854  *
1855  * By default, the owner account will be the one that deploys the contract. This
1856  * can later be changed with {transferOwnership}.
1857  *
1858  * This module is used through inheritance. It will make available the modifier
1859  * `onlyOwner`, which can be applied to your functions to restrict their use to
1860  * the owner.
1861  */
1862 abstract contract Ownable is Context {
1863     address private _owner;
1864 
1865     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1866 
1867     /**
1868      * @dev Initializes the contract setting the deployer as the initial owner.
1869      */
1870     constructor() {
1871         _transferOwnership(_msgSender());
1872     }
1873 
1874     /**
1875      * @dev Throws if called by any account other than the owner.
1876      */
1877     modifier onlyOwner() {
1878         _checkOwner();
1879         _;
1880     }
1881 
1882     /**
1883      * @dev Returns the address of the current owner.
1884      */
1885     function owner() public view virtual returns (address) {
1886         return _owner;
1887     }
1888 
1889     /**
1890      * @dev Throws if the sender is not the owner.
1891      */
1892     function _checkOwner() internal view virtual {
1893         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1894     }
1895 
1896     /**
1897      * @dev Leaves the contract without owner. It will not be possible to call
1898      * `onlyOwner` functions anymore. Can only be called by the current owner.
1899      *
1900      * NOTE: Renouncing ownership will leave the contract without an owner,
1901      * thereby removing any functionality that is only available to the owner.
1902      */
1903     function renounceOwnership() public virtual onlyOwner {
1904         _transferOwnership(address(0));
1905     }
1906 
1907     /**
1908      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1909      * Can only be called by the current owner.
1910      */
1911     function transferOwnership(address newOwner) public virtual onlyOwner {
1912         require(newOwner != address(0), "Ownable: new owner is the zero address");
1913         _transferOwnership(newOwner);
1914     }
1915 
1916     /**
1917      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1918      * Internal function without access restriction.
1919      */
1920     function _transferOwnership(address newOwner) internal virtual {
1921         address oldOwner = _owner;
1922         _owner = newOwner;
1923         emit OwnershipTransferred(oldOwner, newOwner);
1924     }
1925 }
1926 
1927 // File: closedsea/OperatorFilterer.sol
1928 
1929 
1930 pragma solidity ^0.8.4;
1931 
1932 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1933 /// mandatory on-chain royalty enforcement in order for new collections to
1934 /// receive royalties.
1935 /// For more information, see:
1936 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1937 abstract contract OperatorFilterer {
1938     /// @dev The default OpenSea operator blocklist subscription.
1939     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1940 
1941     /// @dev The OpenSea operator filter registry.
1942     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1943 
1944     /// @dev Registers the current contract to OpenSea's operator filter,
1945     /// and subscribe to the default OpenSea operator blocklist.
1946     /// Note: Will not revert nor update existing settings for repeated registration.
1947     function _registerForOperatorFiltering() internal virtual {
1948         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1949     }
1950 
1951     /// @dev Registers the current contract to OpenSea's operator filter.
1952     /// Note: Will not revert nor update existing settings for repeated registration.
1953     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1954         internal
1955         virtual
1956     {
1957         /// @solidity memory-safe-assembly
1958         assembly {
1959             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1960 
1961             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1962             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1963 
1964             for {} iszero(subscribe) {} {
1965                 if iszero(subscriptionOrRegistrantToCopy) {
1966                     functionSelector := 0x4420e486 // `register(address)`.
1967                     break
1968                 }
1969                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1970                 break
1971             }
1972             // Store the function selector.
1973             mstore(0x00, shl(224, functionSelector))
1974             // Store the `address(this)`.
1975             mstore(0x04, address())
1976             // Store the `subscriptionOrRegistrantToCopy`.
1977             mstore(0x24, subscriptionOrRegistrantToCopy)
1978             // Register into the registry.
1979             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
1980                 // If the function selector has not been overwritten,
1981                 // it is an out-of-gas error.
1982                 if eq(shr(224, mload(0x00)), functionSelector) {
1983                     // To prevent gas under-estimation.
1984                     revert(0, 0)
1985                 }
1986             }
1987             // Restore the part of the free memory pointer that was overwritten,
1988             // which is guaranteed to be zero, because of Solidity's memory size limits.
1989             mstore(0x24, 0)
1990         }
1991     }
1992 
1993     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1994     modifier onlyAllowedOperator(address from) virtual {
1995         if (from != msg.sender) {
1996             if (!_isPriorityOperator(msg.sender)) {
1997                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1998             }
1999         }
2000         _;
2001     }
2002 
2003     /// @dev Modifier to guard a function from approving a blocked operator..
2004     modifier onlyAllowedOperatorApproval(address operator) virtual {
2005         if (!_isPriorityOperator(operator)) {
2006             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
2007         }
2008         _;
2009     }
2010 
2011     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
2012     function _revertIfBlocked(address operator) private view {
2013         /// @solidity memory-safe-assembly
2014         assembly {
2015             // Store the function selector of `isOperatorAllowed(address,address)`,
2016             // shifted left by 6 bytes, which is enough for 8tb of memory.
2017             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
2018             mstore(0x00, 0xc6171134001122334455)
2019             // Store the `address(this)`.
2020             mstore(0x1a, address())
2021             // Store the `operator`.
2022             mstore(0x3a, operator)
2023 
2024             // `isOperatorAllowed` always returns true if it does not revert.
2025             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
2026                 // Bubble up the revert if the staticcall reverts.
2027                 returndatacopy(0x00, 0x00, returndatasize())
2028                 revert(0x00, returndatasize())
2029             }
2030 
2031             // We'll skip checking if `from` is inside the blacklist.
2032             // Even though that can block transferring out of wrapper contracts,
2033             // we don't want tokens to be stuck.
2034 
2035             // Restore the part of the free memory pointer that was overwritten,
2036             // which is guaranteed to be zero, if less than 8tb of memory is used.
2037             mstore(0x3a, 0)
2038         }
2039     }
2040 
2041     /// @dev For deriving contracts to override, so that operator filtering
2042     /// can be turned on / off.
2043     /// Returns true by default.
2044     function _operatorFilteringEnabled() internal view virtual returns (bool) {
2045         return true;
2046     }
2047 
2048     /// @dev For deriving contracts to override, so that preferred marketplaces can
2049     /// skip operator filtering, helping users save gas.
2050     /// Returns false for all inputs by default.
2051     function _isPriorityOperator(address) internal view virtual returns (bool) {
2052         return false;
2053     }
2054 }
2055 // File: SaintRobotica.sol
2056 
2057 
2058 pragma solidity ^0.8.7;
2059 
2060 
2061 
2062 
2063 
2064 
2065 contract SaintRobotica is ERC721, EIP712, Ownable, OperatorFilterer {
2066     using Counters for Counters.Counter;
2067 
2068     Counters.Counter _teamTokenIdCounter;
2069     Counters.Counter _prepurchaseTokenIdCounter;
2070     Counters.Counter _tokenIdCounter;
2071 
2072     string _baseUri;
2073     string _contractURI;
2074     address _signerAddress;
2075 
2076     uint256 maxSaleCount;
2077     uint256 reservedCount;
2078 
2079     uint256 public price = 0.15 ether;
2080 
2081     uint256 public presaleStartTimestamp = 1671033600;
2082     uint256 public saleStartTimestamp = 1671035400;
2083     uint256 public saleEndTimestamp = 1702549232;
2084 
2085     uint256 public maxSupply = 3773;
2086 
2087     uint256 public reservedTeamMintCount = 100;
2088     uint256 public reservedPrepurchaseMintCount = 91;
2089 
2090     uint256 public presaleMintLimit = 3;
2091     uint256 public publicSaleMintLimit = 10;
2092 
2093     bool public operatorFilteringEnabled;
2094 
2095     mapping(address => uint256) public presaleMintCounter;
2096     mapping(address => uint256) public publicMintCounter;
2097 
2098     constructor()
2099         ERC721("SaintRobotica", "SR")
2100         EIP712("SaintRobotica", "1.0.0")
2101     {
2102         _registerForOperatorFiltering();
2103         operatorFilteringEnabled = true;
2104         _signerAddress = 0x105727Dc52481aBc7316EB29711F9Bcf1F18f7C6;
2105 
2106         _contractURI = "ipfs://QmTSiR9VAD3W1KCiAhsn6mtzSw8WuAf3qtnea5w6FVr1uP";
2107         _baseUri = "https://saintrobotica.com/api/token/";
2108 
2109         reservedCount = reservedTeamMintCount + reservedPrepurchaseMintCount;
2110         maxSaleCount = maxSupply - reservedCount;
2111     }
2112 
2113     function mint(uint256 quantity) external payable {
2114         require(isSaleActive(), "The sale is not active.");
2115         require(
2116             _tokenIdCounter.current() + quantity <= maxSaleCount,
2117             "The quantity exceeds the remaining amount of public sale capacity."
2118         );
2119         require(
2120             publicMintCounter[msg.sender] + quantity <= publicSaleMintLimit,
2121             "The quantity exceeds the remaining amount of mints available to your wallet. Try fewer mints."
2122         );
2123         require(msg.value >= price * quantity, "Not enough ETH.");
2124 
2125         publicMintCounter[msg.sender] += quantity;
2126 
2127         for (uint256 i = 0; i < quantity; i++) {
2128             safeMint(msg.sender);
2129         }
2130     }
2131 
2132     function presaleMint(
2133         uint256 quantity,
2134         bytes calldata signature
2135     ) external payable {
2136         require(isPresaleActive(), "The presale is not active.");
2137         require(
2138             recoverAddress(msg.sender, signature) == _signerAddress,
2139             "Invalid signature."
2140         );
2141         require(
2142             _tokenIdCounter.current() + quantity <= maxSaleCount,
2143             "The quantity exceeds the amount of remaining mints available."
2144         );
2145         require(
2146             presaleMintCounter[msg.sender] + quantity <= presaleMintLimit,
2147             "The quantity exceeds the remaining amount of mints available to your wallet. Try fewer mints."
2148         );
2149         require(msg.value >= quantity * price, "Not enough ETH.");
2150 
2151         presaleMintCounter[msg.sender] += quantity;
2152 
2153         for (uint256 i = 0; i < quantity; i++) {
2154             safeMint(msg.sender);
2155         }
2156     }
2157 
2158     function safeMint(address to) internal {
2159         uint256 tokenId = _tokenIdCounter.current();
2160         _tokenIdCounter.increment();
2161         _safeMint(to, tokenId + reservedCount);
2162     }
2163 
2164     function teamMint(uint256 quantity) external onlyOwner {
2165         require(
2166             _teamTokenIdCounter.current() + quantity <= reservedTeamMintCount,
2167             "The quantity exceeds the remaining amount of team mint capacity."
2168         );
2169         for (uint256 i = 0; i < quantity; i++) {
2170             uint256 tokenId = _teamTokenIdCounter.current();
2171             _teamTokenIdCounter.increment();
2172             _safeMint(msg.sender, tokenId);
2173         }
2174     }
2175 
2176     function prepurchaseMint(
2177         address account,
2178         uint256 quantity
2179     ) external onlyOwner {
2180         require(
2181             _prepurchaseTokenIdCounter.current() + quantity <=
2182                 reservedPrepurchaseMintCount,
2183             "The quantity exceeds the remaining amount of prepurchase mint capacity."
2184         );
2185         for (uint256 i = 0; i < quantity; i++) {
2186             uint256 tokenId = _prepurchaseTokenIdCounter.current();
2187             _prepurchaseTokenIdCounter.increment();
2188             _safeMint(account, tokenId + reservedTeamMintCount);
2189         }
2190     }
2191 
2192     function isPresaleActive() public view returns (bool) {
2193         return
2194             block.timestamp >= presaleStartTimestamp &&
2195             block.timestamp < saleStartTimestamp;
2196     }
2197 
2198     function isSaleActive() public view returns (bool) {
2199         return
2200             block.timestamp >= saleStartTimestamp &&
2201             block.timestamp <= saleEndTimestamp;
2202     }
2203 
2204     function totalSupply() public view returns (uint256) {
2205         return
2206             _teamTokenIdCounter.current() +
2207             _prepurchaseTokenIdCounter.current() +
2208             _tokenIdCounter.current();
2209     }
2210 
2211     function setSaleDates(
2212         uint256 presale,
2213         uint256 start,
2214         uint256 end
2215     ) external onlyOwner {
2216         require(
2217             start >= presale,
2218             "The sale start date should be greater than or equal to the presale start date"
2219         );
2220         require(
2221             end > start,
2222             "The sale end date should be greater than the sale start date"
2223         );
2224 
2225         presaleStartTimestamp = presale;
2226         saleStartTimestamp = start;
2227         saleEndTimestamp = end;
2228     }
2229 
2230     function setBaseURI(string memory newBaseURI) external onlyOwner {
2231         _baseUri = newBaseURI;
2232     }
2233 
2234     function setContractURI(string memory newContractURI) external onlyOwner {
2235         _contractURI = newContractURI;
2236     }
2237 
2238     function setPrice(uint256 newPrice) external onlyOwner {
2239         price = newPrice;
2240     }
2241 
2242     function withdraw(uint256 amount) external onlyOwner {
2243         require(payable(msg.sender).send(amount));
2244     }
2245 
2246     function withdrawAll() external onlyOwner {
2247         require(payable(msg.sender).send(address(this).balance));
2248     }
2249 
2250     function setSignerAddress(address signerAddress) public onlyOwner {
2251         _signerAddress = signerAddress;
2252     }
2253 
2254     function setOperatorFilteringEnabled(bool value) public onlyOwner {
2255         operatorFilteringEnabled = value;
2256     }
2257 
2258     function recoverAddress(
2259         address account,
2260         bytes calldata signature
2261     ) public view returns (address) {
2262         return
2263             ECDSA.recover(
2264                 _hashTypedDataV4(
2265                     keccak256(
2266                         abi.encode(
2267                             keccak256("InnerCircle(address account)"),
2268                             account
2269                         )
2270                     )
2271                 ),
2272                 signature
2273             );
2274     }
2275 
2276     function contractURI() public view returns (string memory) {
2277         return _contractURI;
2278     }
2279 
2280     function _baseURI() internal view override returns (string memory) {
2281         return _baseUri;
2282     }
2283 
2284     function _operatorFilteringEnabled() internal view override returns (bool) {
2285         return operatorFilteringEnabled;
2286     }
2287 
2288     function _isPriorityOperator(
2289         address operator
2290     ) internal pure override returns (bool) {
2291         return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
2292     }
2293 
2294     // @dev Operator Filterer overrides
2295 
2296     function setApprovalForAll(
2297         address operator,
2298         bool approved
2299     ) public override onlyAllowedOperatorApproval(operator) {
2300         super.setApprovalForAll(operator, approved);
2301     }
2302 
2303     function approve(
2304         address operator,
2305         uint256 tokenId
2306     ) public override onlyAllowedOperatorApproval(operator) {
2307         super.approve(operator, tokenId);
2308     }
2309 
2310     function transferFrom(
2311         address from,
2312         address to,
2313         uint256 tokenId
2314     ) public override onlyAllowedOperator(from) {
2315         super.transferFrom(from, to, tokenId);
2316     }
2317 
2318     function safeTransferFrom(
2319         address from,
2320         address to,
2321         uint256 tokenId
2322     ) public override onlyAllowedOperator(from) {
2323         super.safeTransferFrom(from, to, tokenId);
2324     }
2325 
2326     function safeTransferFrom(
2327         address from,
2328         address to,
2329         uint256 tokenId,
2330         bytes memory data
2331     ) public override onlyAllowedOperator(from) {
2332         super.safeTransferFrom(from, to, tokenId, data);
2333     }
2334 }