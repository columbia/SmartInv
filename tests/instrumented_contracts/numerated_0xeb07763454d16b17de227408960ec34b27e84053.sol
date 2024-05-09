1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.2
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.9.2
28 
29 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
30 
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(address from, address to, uint256 tokenId) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
100      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
101      * understand this adds an external call which potentially creates a reentrancy vulnerability.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool approved) external;
140 
141     /**
142      * @dev Returns the account approved for `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function getApproved(uint256 tokenId) external view returns (address operator);
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 }
157 
158 
159 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.9.2
160 
161 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
162 
163 
164 /**
165  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
166  * @dev See https://eips.ethereum.org/EIPS/eip-721
167  */
168 interface IERC721Metadata is IERC721 {
169     /**
170      * @dev Returns the token collection name.
171      */
172     function name() external view returns (string memory);
173 
174     /**
175      * @dev Returns the token collection symbol.
176      */
177     function symbol() external view returns (string memory);
178 
179     /**
180      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
181      */
182     function tokenURI(uint256 tokenId) external view returns (string memory);
183 }
184 
185 
186 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.9.2
187 
188 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
189 
190 /**
191  * @title ERC721 token receiver interface
192  * @dev Interface for any contract that wants to support safeTransfers
193  * from ERC721 asset contracts.
194  */
195 interface IERC721Receiver {
196     /**
197      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
198      * by `operator` from `from`, this function is called.
199      *
200      * It must return its Solidity selector to confirm the token transfer.
201      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
202      *
203      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
204      */
205     function onERC721Received(
206         address operator,
207         address from,
208         uint256 tokenId,
209         bytes calldata data
210     ) external returns (bytes4);
211 }
212 
213 
214 // File @openzeppelin/contracts/utils/Address.sol@v4.9.2
215 
216 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
217 
218 
219 /**
220  * @dev Collection of functions related to the address type
221  */
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      *
239      * Furthermore, `isContract` will also return true if the target contract within
240      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
241      * which only has an effect at the end of a transaction.
242      * ====
243      *
244      * [IMPORTANT]
245      * ====
246      * You shouldn't rely on `isContract` to protect against flash loan attacks!
247      *
248      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
249      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
250      * constructor.
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize/address.code.length, which returns 0
255         // for contracts in construction, since the code is only stored at the end
256         // of the constructor execution.
257 
258         return account.code.length > 0;
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         (bool success, ) = recipient.call{value: amount}("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain `call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, 0, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but also transferring `value` wei to `target`.
323      *
324      * Requirements:
325      *
326      * - the calling contract must have an ETH balance of at least `value`.
327      * - the called Solidity function must be `payable`.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337      * with `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         (bool success, bytes memory returndata) = target.call{value: value}(data);
349         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         (bool success, bytes memory returndata) = target.staticcall(data);
374         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         (bool success, bytes memory returndata) = target.delegatecall(data);
399         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
404      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
405      *
406      * _Available since v4.8._
407      */
408     function verifyCallResultFromTarget(
409         address target,
410         bool success,
411         bytes memory returndata,
412         string memory errorMessage
413     ) internal view returns (bytes memory) {
414         if (success) {
415             if (returndata.length == 0) {
416                 // only check isContract if the call was successful and the return data is empty
417                 // otherwise we already know that it was a contract
418                 require(isContract(target), "Address: call to non-contract");
419             }
420             return returndata;
421         } else {
422             _revert(returndata, errorMessage);
423         }
424     }
425 
426     /**
427      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
428      * revert reason or using the provided one.
429      *
430      * _Available since v4.3._
431      */
432     function verifyCallResult(
433         bool success,
434         bytes memory returndata,
435         string memory errorMessage
436     ) internal pure returns (bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             _revert(returndata, errorMessage);
441         }
442     }
443 
444     function _revert(bytes memory returndata, string memory errorMessage) private pure {
445         // Look for revert reason and bubble it up if present
446         if (returndata.length > 0) {
447             // The easiest way to bubble the revert reason is using memory via assembly
448             /// @solidity memory-safe-assembly
449             assembly {
450                 let returndata_size := mload(returndata)
451                 revert(add(32, returndata), returndata_size)
452             }
453         } else {
454             revert(errorMessage);
455         }
456     }
457 }
458 
459 
460 // File @openzeppelin/contracts/utils/Context.sol@v4.9.2
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
463 
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 
486 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.9.2
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
489 
490 
491 /**
492  * @dev Implementation of the {IERC165} interface.
493  *
494  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
495  * for the additional interface id that will be supported. For example:
496  *
497  * ```solidity
498  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
500  * }
501  * ```
502  *
503  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
504  */
505 abstract contract ERC165 is IERC165 {
506     /**
507      * @dev See {IERC165-supportsInterface}.
508      */
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return interfaceId == type(IERC165).interfaceId;
511     }
512 }
513 
514 
515 // File @openzeppelin/contracts/utils/math/Math.sol@v4.9.2
516 
517 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
518 
519 
520 /**
521  * @dev Standard math utilities missing in the Solidity language.
522  */
523 library Math {
524     enum Rounding {
525         Down, // Toward negative infinity
526         Up, // Toward infinity
527         Zero // Toward zero
528     }
529 
530     /**
531      * @dev Returns the largest of two numbers.
532      */
533     function max(uint256 a, uint256 b) internal pure returns (uint256) {
534         return a > b ? a : b;
535     }
536 
537     /**
538      * @dev Returns the smallest of two numbers.
539      */
540     function min(uint256 a, uint256 b) internal pure returns (uint256) {
541         return a < b ? a : b;
542     }
543 
544     /**
545      * @dev Returns the average of two numbers. The result is rounded towards
546      * zero.
547      */
548     function average(uint256 a, uint256 b) internal pure returns (uint256) {
549         // (a + b) / 2 can overflow.
550         return (a & b) + (a ^ b) / 2;
551     }
552 
553     /**
554      * @dev Returns the ceiling of the division of two numbers.
555      *
556      * This differs from standard division with `/` in that it rounds up instead
557      * of rounding down.
558      */
559     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
560         // (a + b - 1) / b can overflow on addition, so we distribute.
561         return a == 0 ? 0 : (a - 1) / b + 1;
562     }
563 
564     /**
565      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
566      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
567      * with further edits by Uniswap Labs also under MIT license.
568      */
569     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
570         unchecked {
571             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
572             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
573             // variables such that product = prod1 * 2^256 + prod0.
574             uint256 prod0; // Least significant 256 bits of the product
575             uint256 prod1; // Most significant 256 bits of the product
576             assembly {
577                 let mm := mulmod(x, y, not(0))
578                 prod0 := mul(x, y)
579                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
580             }
581 
582             // Handle non-overflow cases, 256 by 256 division.
583             if (prod1 == 0) {
584                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
585                 // The surrounding unchecked block does not change this fact.
586                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
587                 return prod0 / denominator;
588             }
589 
590             // Make sure the result is less than 2^256. Also prevents denominator == 0.
591             require(denominator > prod1, "Math: mulDiv overflow");
592 
593             ///////////////////////////////////////////////
594             // 512 by 256 division.
595             ///////////////////////////////////////////////
596 
597             // Make division exact by subtracting the remainder from [prod1 prod0].
598             uint256 remainder;
599             assembly {
600                 // Compute remainder using mulmod.
601                 remainder := mulmod(x, y, denominator)
602 
603                 // Subtract 256 bit number from 512 bit number.
604                 prod1 := sub(prod1, gt(remainder, prod0))
605                 prod0 := sub(prod0, remainder)
606             }
607 
608             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
609             // See https://cs.stackexchange.com/q/138556/92363.
610 
611             // Does not overflow because the denominator cannot be zero at this stage in the function.
612             uint256 twos = denominator & (~denominator + 1);
613             assembly {
614                 // Divide denominator by twos.
615                 denominator := div(denominator, twos)
616 
617                 // Divide [prod1 prod0] by twos.
618                 prod0 := div(prod0, twos)
619 
620                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
621                 twos := add(div(sub(0, twos), twos), 1)
622             }
623 
624             // Shift in bits from prod1 into prod0.
625             prod0 |= prod1 * twos;
626 
627             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
628             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
629             // four bits. That is, denominator * inv = 1 mod 2^4.
630             uint256 inverse = (3 * denominator) ^ 2;
631 
632             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
633             // in modular arithmetic, doubling the correct bits in each step.
634             inverse *= 2 - denominator * inverse; // inverse mod 2^8
635             inverse *= 2 - denominator * inverse; // inverse mod 2^16
636             inverse *= 2 - denominator * inverse; // inverse mod 2^32
637             inverse *= 2 - denominator * inverse; // inverse mod 2^64
638             inverse *= 2 - denominator * inverse; // inverse mod 2^128
639             inverse *= 2 - denominator * inverse; // inverse mod 2^256
640 
641             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
642             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
643             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
644             // is no longer required.
645             result = prod0 * inverse;
646             return result;
647         }
648     }
649 
650     /**
651      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
652      */
653     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
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
769             if (value >= 10 ** 64) {
770                 value /= 10 ** 64;
771                 result += 64;
772             }
773             if (value >= 10 ** 32) {
774                 value /= 10 ** 32;
775                 result += 32;
776             }
777             if (value >= 10 ** 16) {
778                 value /= 10 ** 16;
779                 result += 16;
780             }
781             if (value >= 10 ** 8) {
782                 value /= 10 ** 8;
783                 result += 8;
784             }
785             if (value >= 10 ** 4) {
786                 value /= 10 ** 4;
787                 result += 4;
788             }
789             if (value >= 10 ** 2) {
790                 value /= 10 ** 2;
791                 result += 2;
792             }
793             if (value >= 10 ** 1) {
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
807             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
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
844      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
845      * Returns 0 if given 0.
846      */
847     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
848         unchecked {
849             uint256 result = log256(value);
850             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
851         }
852     }
853 }
854 
855 
856 // File @openzeppelin/contracts/utils/math/SignedMath.sol@v4.9.2
857 
858 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
859 
860 
861 /**
862  * @dev Standard signed math utilities missing in the Solidity language.
863  */
864 library SignedMath {
865     /**
866      * @dev Returns the largest of two signed numbers.
867      */
868     function max(int256 a, int256 b) internal pure returns (int256) {
869         return a > b ? a : b;
870     }
871 
872     /**
873      * @dev Returns the smallest of two signed numbers.
874      */
875     function min(int256 a, int256 b) internal pure returns (int256) {
876         return a < b ? a : b;
877     }
878 
879     /**
880      * @dev Returns the average of two signed numbers without overflow.
881      * The result is rounded towards zero.
882      */
883     function average(int256 a, int256 b) internal pure returns (int256) {
884         // Formula from the book "Hacker's Delight"
885         int256 x = (a & b) + ((a ^ b) >> 1);
886         return x + (int256(uint256(x) >> 255) & (a ^ b));
887     }
888 
889     /**
890      * @dev Returns the absolute unsigned value of a signed value.
891      */
892     function abs(int256 n) internal pure returns (uint256) {
893         unchecked {
894             // must be unchecked in order to support `n = type(int256).min`
895             return uint256(n >= 0 ? n : -n);
896         }
897     }
898 }
899 
900 
901 // File @openzeppelin/contracts/utils/Strings.sol@v4.9.2
902 
903 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
904 
905 
906 
907 /**
908  * @dev String operations.
909  */
910 library Strings {
911     bytes16 private constant _SYMBOLS = "0123456789abcdef";
912     uint8 private constant _ADDRESS_LENGTH = 20;
913 
914     /**
915      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
916      */
917     function toString(uint256 value) internal pure returns (string memory) {
918         unchecked {
919             uint256 length = Math.log10(value) + 1;
920             string memory buffer = new string(length);
921             uint256 ptr;
922             /// @solidity memory-safe-assembly
923             assembly {
924                 ptr := add(buffer, add(32, length))
925             }
926             while (true) {
927                 ptr--;
928                 /// @solidity memory-safe-assembly
929                 assembly {
930                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
931                 }
932                 value /= 10;
933                 if (value == 0) break;
934             }
935             return buffer;
936         }
937     }
938 
939     /**
940      * @dev Converts a `int256` to its ASCII `string` decimal representation.
941      */
942     function toString(int256 value) internal pure returns (string memory) {
943         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
944     }
945 
946     /**
947      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
948      */
949     function toHexString(uint256 value) internal pure returns (string memory) {
950         unchecked {
951             return toHexString(value, Math.log256(value) + 1);
952         }
953     }
954 
955     /**
956      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
957      */
958     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
959         bytes memory buffer = new bytes(2 * length + 2);
960         buffer[0] = "0";
961         buffer[1] = "x";
962         for (uint256 i = 2 * length + 1; i > 1; --i) {
963             buffer[i] = _SYMBOLS[value & 0xf];
964             value >>= 4;
965         }
966         require(value == 0, "Strings: hex length insufficient");
967         return string(buffer);
968     }
969 
970     /**
971      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
972      */
973     function toHexString(address addr) internal pure returns (string memory) {
974         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
975     }
976 
977     /**
978      * @dev Returns true if the two strings are equal.
979      */
980     function equal(string memory a, string memory b) internal pure returns (bool) {
981         return keccak256(bytes(a)) == keccak256(bytes(b));
982     }
983 }
984 
985 
986 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.9.2
987 
988 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/ERC721.sol)
989 
990 
991 
992 /**
993  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
994  * the Metadata extension, but not including the Enumerable extension, which is available separately as
995  * {ERC721Enumerable}.
996  */
997 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
998     using Address for address;
999     using Strings for uint256;
1000 
1001     // Token name
1002     string private _name;
1003 
1004     // Token symbol
1005     string private _symbol;
1006 
1007     // Mapping from token ID to owner address
1008     mapping(uint256 => address) private _owners;
1009 
1010     // Mapping owner address to token count
1011     mapping(address => uint256) private _balances;
1012 
1013     // Mapping from token ID to approved address
1014     mapping(uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     /**
1020      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1021      */
1022     constructor(string memory name_, string memory symbol_) {
1023         _name = name_;
1024         _symbol = symbol_;
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1031         return
1032             interfaceId == type(IERC721).interfaceId ||
1033             interfaceId == type(IERC721Metadata).interfaceId ||
1034             super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-balanceOf}.
1039      */
1040     function balanceOf(address owner) public view virtual override returns (uint256) {
1041         require(owner != address(0), "ERC721: address zero is not a valid owner");
1042         return _balances[owner];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-ownerOf}.
1047      */
1048     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1049         address owner = _ownerOf(tokenId);
1050         require(owner != address(0), "ERC721: invalid token ID");
1051         return owner;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-name}.
1056      */
1057     function name() public view virtual override returns (string memory) {
1058         return _name;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-symbol}.
1063      */
1064     function symbol() public view virtual override returns (string memory) {
1065         return _symbol;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-tokenURI}.
1070      */
1071     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1072         _requireMinted(tokenId);
1073 
1074         string memory baseURI = _baseURI();
1075         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1076     }
1077 
1078     /**
1079      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1080      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1081      * by default, can be overridden in child contracts.
1082      */
1083     function _baseURI() internal view virtual returns (string memory) {
1084         return "";
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-approve}.
1089      */
1090     function approve(address to, uint256 tokenId) public virtual override {
1091         address owner = ERC721.ownerOf(tokenId);
1092         require(to != owner, "ERC721: approval to current owner");
1093 
1094         require(
1095             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1096             "ERC721: approve caller is not token owner or approved for all"
1097         );
1098 
1099         _approve(to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-getApproved}.
1104      */
1105     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1106         _requireMinted(tokenId);
1107 
1108         return _tokenApprovals[tokenId];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-setApprovalForAll}.
1113      */
1114     function setApprovalForAll(address operator, bool approved) public virtual override {
1115         _setApprovalForAll(_msgSender(), operator, approved);
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-isApprovedForAll}.
1120      */
1121     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1122         return _operatorApprovals[owner][operator];
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-transferFrom}.
1127      */
1128     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1129         //solhint-disable-next-line max-line-length
1130         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1131 
1132         _transfer(from, to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-safeTransferFrom}.
1137      */
1138     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1139         safeTransferFrom(from, to, tokenId, "");
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-safeTransferFrom}.
1144      */
1145     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1146         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1147         _safeTransfer(from, to, tokenId, data);
1148     }
1149 
1150     /**
1151      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1152      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1153      *
1154      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1155      *
1156      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1157      * implement alternative mechanisms to perform token transfer, such as signature-based.
1158      *
1159      * Requirements:
1160      *
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must exist and be owned by `from`.
1164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1169         _transfer(from, to, tokenId);
1170         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1171     }
1172 
1173     /**
1174      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1175      */
1176     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1177         return _owners[tokenId];
1178     }
1179 
1180     /**
1181      * @dev Returns whether `tokenId` exists.
1182      *
1183      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1184      *
1185      * Tokens start existing when they are minted (`_mint`),
1186      * and stop existing when they are burned (`_burn`).
1187      */
1188     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1189         return _ownerOf(tokenId) != address(0);
1190     }
1191 
1192     /**
1193      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      */
1199     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1200         address owner = ERC721.ownerOf(tokenId);
1201         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1202     }
1203 
1204     /**
1205      * @dev Safely mints `tokenId` and transfers it to `to`.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must not exist.
1210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _safeMint(address to, uint256 tokenId) internal virtual {
1215         _safeMint(to, tokenId, "");
1216     }
1217 
1218     /**
1219      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1220      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1221      */
1222     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1223         _mint(to, tokenId);
1224         require(
1225             _checkOnERC721Received(address(0), to, tokenId, data),
1226             "ERC721: transfer to non ERC721Receiver implementer"
1227         );
1228     }
1229 
1230     /**
1231      * @dev Mints `tokenId` and transfers it to `to`.
1232      *
1233      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must not exist.
1238      * - `to` cannot be the zero address.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _mint(address to, uint256 tokenId) internal virtual {
1243         require(to != address(0), "ERC721: mint to the zero address");
1244         require(!_exists(tokenId), "ERC721: token already minted");
1245 
1246         _beforeTokenTransfer(address(0), to, tokenId, 1);
1247 
1248         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1249         require(!_exists(tokenId), "ERC721: token already minted");
1250 
1251         unchecked {
1252             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1253             // Given that tokens are minted one by one, it is impossible in practice that
1254             // this ever happens. Might change if we allow batch minting.
1255             // The ERC fails to describe this case.
1256             _balances[to] += 1;
1257         }
1258 
1259         _owners[tokenId] = to;
1260 
1261         emit Transfer(address(0), to, tokenId);
1262 
1263         _afterTokenTransfer(address(0), to, tokenId, 1);
1264     }
1265 
1266     /**
1267      * @dev Destroys `tokenId`.
1268      * The approval is cleared when the token is burned.
1269      * This is an internal function that does not check if the sender is authorized to operate on the token.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must exist.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _burn(uint256 tokenId) internal virtual {
1278         address owner = ERC721.ownerOf(tokenId);
1279 
1280         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1281 
1282         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1283         owner = ERC721.ownerOf(tokenId);
1284 
1285         // Clear approvals
1286         delete _tokenApprovals[tokenId];
1287 
1288         unchecked {
1289             // Cannot overflow, as that would require more tokens to be burned/transferred
1290             // out than the owner initially received through minting and transferring in.
1291             _balances[owner] -= 1;
1292         }
1293         delete _owners[tokenId];
1294 
1295         emit Transfer(owner, address(0), tokenId);
1296 
1297         _afterTokenTransfer(owner, address(0), tokenId, 1);
1298     }
1299 
1300     /**
1301      * @dev Transfers `tokenId` from `from` to `to`.
1302      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `tokenId` token must be owned by `from`.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1312         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1313         require(to != address(0), "ERC721: transfer to the zero address");
1314 
1315         _beforeTokenTransfer(from, to, tokenId, 1);
1316 
1317         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1318         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1319 
1320         // Clear approvals from the previous owner
1321         delete _tokenApprovals[tokenId];
1322 
1323         unchecked {
1324             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1325             // `from`'s balance is the number of token held, which is at least one before the current
1326             // transfer.
1327             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1328             // all 2**256 token ids to be minted, which in practice is impossible.
1329             _balances[from] -= 1;
1330             _balances[to] += 1;
1331         }
1332         _owners[tokenId] = to;
1333 
1334         emit Transfer(from, to, tokenId);
1335 
1336         _afterTokenTransfer(from, to, tokenId, 1);
1337     }
1338 
1339     /**
1340      * @dev Approve `to` to operate on `tokenId`
1341      *
1342      * Emits an {Approval} event.
1343      */
1344     function _approve(address to, uint256 tokenId) internal virtual {
1345         _tokenApprovals[tokenId] = to;
1346         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev Approve `operator` to operate on all of `owner` tokens
1351      *
1352      * Emits an {ApprovalForAll} event.
1353      */
1354     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1355         require(owner != operator, "ERC721: approve to caller");
1356         _operatorApprovals[owner][operator] = approved;
1357         emit ApprovalForAll(owner, operator, approved);
1358     }
1359 
1360     /**
1361      * @dev Reverts if the `tokenId` has not been minted yet.
1362      */
1363     function _requireMinted(uint256 tokenId) internal view virtual {
1364         require(_exists(tokenId), "ERC721: invalid token ID");
1365     }
1366 
1367     /**
1368      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1369      * The call is not executed if the target address is not a contract.
1370      *
1371      * @param from address representing the previous owner of the given token ID
1372      * @param to target address that will receive the tokens
1373      * @param tokenId uint256 ID of the token to be transferred
1374      * @param data bytes optional data to send along with the call
1375      * @return bool whether the call correctly returned the expected magic value
1376      */
1377     function _checkOnERC721Received(
1378         address from,
1379         address to,
1380         uint256 tokenId,
1381         bytes memory data
1382     ) private returns (bool) {
1383         if (to.isContract()) {
1384             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1385                 return retval == IERC721Receiver.onERC721Received.selector;
1386             } catch (bytes memory reason) {
1387                 if (reason.length == 0) {
1388                     revert("ERC721: transfer to non ERC721Receiver implementer");
1389                 } else {
1390                     /// @solidity memory-safe-assembly
1391                     assembly {
1392                         revert(add(32, reason), mload(reason))
1393                     }
1394                 }
1395             }
1396         } else {
1397             return true;
1398         }
1399     }
1400 
1401     /**
1402      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1403      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1408      * - When `from` is zero, the tokens will be minted for `to`.
1409      * - When `to` is zero, ``from``'s tokens will be burned.
1410      * - `from` and `to` are never both zero.
1411      * - `batchSize` is non-zero.
1412      *
1413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1414      */
1415     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1416 
1417     /**
1418      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1419      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1424      * - When `from` is zero, the tokens were minted for `to`.
1425      * - When `to` is zero, ``from``'s tokens were burned.
1426      * - `from` and `to` are never both zero.
1427      * - `batchSize` is non-zero.
1428      *
1429      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1430      */
1431     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1432 
1433     /**
1434      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1435      *
1436      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1437      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1438      * that `ownerOf(tokenId)` is `a`.
1439      */
1440     // solhint-disable-next-line func-name-mixedcase
1441     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1442         _balances[account] += amount;
1443     }
1444 }
1445 
1446 
1447 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.9.2
1448 
1449 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1450 
1451 
1452 /**
1453  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1454  * @dev See https://eips.ethereum.org/EIPS/eip-721
1455  */
1456 interface IERC721Enumerable is IERC721 {
1457     /**
1458      * @dev Returns the total amount of tokens stored by the contract.
1459      */
1460     function totalSupply() external view returns (uint256);
1461 
1462     /**
1463      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1464      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1465      */
1466     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1467 
1468     /**
1469      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1470      * Use along with {totalSupply} to enumerate all tokens.
1471      */
1472     function tokenByIndex(uint256 index) external view returns (uint256);
1473 }
1474 
1475 
1476 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.9.2
1477 
1478 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1479 
1480 
1481 
1482 /**
1483  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1484  * enumerability of all the token ids in the contract as well as all token ids owned by each
1485  * account.
1486  */
1487 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1488     // Mapping from owner to list of owned token IDs
1489     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1490 
1491     // Mapping from token ID to index of the owner tokens list
1492     mapping(uint256 => uint256) private _ownedTokensIndex;
1493 
1494     // Array with all token ids, used for enumeration
1495     uint256[] private _allTokens;
1496 
1497     // Mapping from token id to position in the allTokens array
1498     mapping(uint256 => uint256) private _allTokensIndex;
1499 
1500     /**
1501      * @dev See {IERC165-supportsInterface}.
1502      */
1503     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1504         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1509      */
1510     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1511         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1512         return _ownedTokens[owner][index];
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-totalSupply}.
1517      */
1518     function totalSupply() public view virtual override returns (uint256) {
1519         return _allTokens.length;
1520     }
1521 
1522     /**
1523      * @dev See {IERC721Enumerable-tokenByIndex}.
1524      */
1525     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1526         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1527         return _allTokens[index];
1528     }
1529 
1530     /**
1531      * @dev See {ERC721-_beforeTokenTransfer}.
1532      */
1533     function _beforeTokenTransfer(
1534         address from,
1535         address to,
1536         uint256 firstTokenId,
1537         uint256 batchSize
1538     ) internal virtual override {
1539         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1540 
1541         if (batchSize > 1) {
1542             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1543             revert("ERC721Enumerable: consecutive transfers not supported");
1544         }
1545 
1546         uint256 tokenId = firstTokenId;
1547 
1548         if (from == address(0)) {
1549             _addTokenToAllTokensEnumeration(tokenId);
1550         } else if (from != to) {
1551             _removeTokenFromOwnerEnumeration(from, tokenId);
1552         }
1553         if (to == address(0)) {
1554             _removeTokenFromAllTokensEnumeration(tokenId);
1555         } else if (to != from) {
1556             _addTokenToOwnerEnumeration(to, tokenId);
1557         }
1558     }
1559 
1560     /**
1561      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1562      * @param to address representing the new owner of the given token ID
1563      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1564      */
1565     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1566         uint256 length = ERC721.balanceOf(to);
1567         _ownedTokens[to][length] = tokenId;
1568         _ownedTokensIndex[tokenId] = length;
1569     }
1570 
1571     /**
1572      * @dev Private function to add a token to this extension's token tracking data structures.
1573      * @param tokenId uint256 ID of the token to be added to the tokens list
1574      */
1575     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1576         _allTokensIndex[tokenId] = _allTokens.length;
1577         _allTokens.push(tokenId);
1578     }
1579 
1580     /**
1581      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1582      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1583      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1584      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1585      * @param from address representing the previous owner of the given token ID
1586      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1587      */
1588     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1589         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1590         // then delete the last slot (swap and pop).
1591 
1592         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1593         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1594 
1595         // When the token to delete is the last token, the swap operation is unnecessary
1596         if (tokenIndex != lastTokenIndex) {
1597             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1598 
1599             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1600             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1601         }
1602 
1603         // This also deletes the contents at the last position of the array
1604         delete _ownedTokensIndex[tokenId];
1605         delete _ownedTokens[from][lastTokenIndex];
1606     }
1607 
1608     /**
1609      * @dev Private function to remove a token from this extension's token tracking data structures.
1610      * This has O(1) time complexity, but alters the order of the _allTokens array.
1611      * @param tokenId uint256 ID of the token to be removed from the tokens list
1612      */
1613     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1614         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1615         // then delete the last slot (swap and pop).
1616 
1617         uint256 lastTokenIndex = _allTokens.length - 1;
1618         uint256 tokenIndex = _allTokensIndex[tokenId];
1619 
1620         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1621         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1622         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1623         uint256 lastTokenId = _allTokens[lastTokenIndex];
1624 
1625         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1626         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1627 
1628         // This also deletes the contents at the last position of the array
1629         delete _allTokensIndex[tokenId];
1630         _allTokens.pop();
1631     }
1632 }
1633 
1634 
1635 // File contracts/KoyeExchange.sol
1636 
1637 pragma solidity ^0.8.18;
1638 contract KoyeExchange {
1639     
1640     address public miniKoye = 0x8F5Be6eE538c8E4B2BCfbF51D824Cb9d294D1567;
1641     address public dead = 0x000000000000000000000000000000000000dEaD;
1642     event Destory(address from, uint256 tokenId);
1643 
1644     function destroy(uint256 tokenId) public {
1645         IERC721(miniKoye).safeTransferFrom(msg.sender, dead, tokenId);
1646         emit Destory(msg.sender, tokenId);
1647     }
1648 
1649     function batchDestroy(uint256[] memory tokenIds) public {
1650         for (uint256 i = 0; i < tokenIds.length; i++) {
1651             IERC721(miniKoye).safeTransferFrom(msg.sender, dead, tokenIds[i]);
1652             emit Destory(msg.sender, tokenIds[i]);
1653         }
1654     }
1655 
1656     function getUserTokenIds(address nft_, address user)
1657         public
1658         view
1659         returns (uint256[] memory)
1660     {
1661         uint256 amount = IERC721(nft_).balanceOf(user);
1662         uint256[] memory tokenIds = new uint256[](amount);
1663         if (amount >= 0) {
1664             for (uint256 i; i < amount; ) {
1665                 tokenIds[i] = IERC721Enumerable(nft_).tokenOfOwnerByIndex(
1666                     user,
1667                     i
1668                 );
1669                 unchecked {
1670                     ++i;
1671                 }
1672             }
1673         }
1674 
1675         return tokenIds;
1676     }
1677 }