1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
168 /**
169  * @title Interface for CooGenesis ERC721 contract
170  * @notice Defines the interface for the ERC721 contract, minting criteria object and the relevant methods.
171  */
172 
173 interface ICooGenesis is IERC721 {
174     // === ERC721 ===
175 
176     /**
177      * @return totalSupply - the number of NFTs minted by the contract
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @return maxSupply - the maximum number of NFTs can be minted by the contract
183      */
184     function maxSupply() external view returns (uint256);
185 
186     /**
187      * @notice - Mints an NFT, as long as the current supply is less than {{ maxSupply }} and a valid Wormhole VAA is provided
188      * @param encodedVm - Signed Wormhole VAA
189      */
190     function mint(bytes memory encodedVm) external;
191 
192     /**
193      * @param owner - the address to query tokenId
194      * @return tokenId - the tokenID that is owned by the provided address
195      */
196     function getTokenIdFromAddress(address owner) external view returns (uint256);
197 
198     // === MINTING LOGIC INTERFACE ===
199 
200     /**
201      * @title Wormhole VAA Hash Criterion Definition
202      * @notice This object defines the required criterion that the provided Wormhole VAA must meet, to become eligible for NFT Minting.
203      * @param intervalBegin - The timestamp when the criterion begins to take effect. It must not be less than {{ startTime }}
204      * @param luckyNumber - the numerator - controls magnitude
205      * @param bitNum - the number of bits from the most right to match - controls granularity
206      */
207     struct HashCriterion {
208         uint256 intervalBegin;
209         uint256 luckyNumber;
210         uint256 bitNum;
211     }
212 
213     /**
214      * Verifies minting eligibility for the given Wormhole VAA
215      * Eligibility requirements:
216      * 1. Wormhole Hash must match with the criterion defined based on the timestamp when the VAA has been produced
217      * 2. A recipient is only eligible to mint 1 NFT at max
218      * For off-chain calls, msgSender must be explicitly provided to verify for eligibility
219      * @param encodedVm - The Wormhole VAA to be verified
220      * @return to - eligible address
221      */
222     function isMintingEligible(bytes memory encodedVm) external view returns (address to);
223 
224     /**
225      * @return criteria - A list of criteria that have been configured
226      * @dev - It is recommended to only use this method for non state-changing functions
227      * Otherwise, it may cost a significant amount of gas
228      */
229     function printAllCriteria() external view returns (HashCriterion[] memory);
230 
231     /**
232      * @return startTime - Minting is allowed after this timestamp
233      */
234     function startTime() external view returns (uint256);
235 
236     /**
237      * @return endTime - Minting is no longer allowed after this timestamp
238      */
239     function endTime() external view returns (uint256);
240 }
241 
242 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
243 
244 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
245 
246 /**
247  * @dev External interface of AccessControl declared to support ERC165 detection.
248  */
249 interface IAccessControl {
250     /**
251      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
252      *
253      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
254      * {RoleAdminChanged} not being emitted signaling this.
255      *
256      * _Available since v3.1._
257      */
258     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
259 
260     /**
261      * @dev Emitted when `account` is granted `role`.
262      *
263      * `sender` is the account that originated the contract call, an admin role
264      * bearer except when using {AccessControl-_setupRole}.
265      */
266     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
267 
268     /**
269      * @dev Emitted when `account` is revoked `role`.
270      *
271      * `sender` is the account that originated the contract call:
272      *   - if using `revokeRole`, it is the admin role bearer
273      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
274      */
275     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
276 
277     /**
278      * @dev Returns `true` if `account` has been granted `role`.
279      */
280     function hasRole(bytes32 role, address account) external view returns (bool);
281 
282     /**
283      * @dev Returns the admin role that controls `role`. See {grantRole} and
284      * {revokeRole}.
285      *
286      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
287      */
288     function getRoleAdmin(bytes32 role) external view returns (bytes32);
289 
290     /**
291      * @dev Grants `role` to `account`.
292      *
293      * If `account` had not been already granted `role`, emits a {RoleGranted}
294      * event.
295      *
296      * Requirements:
297      *
298      * - the caller must have ``role``'s admin role.
299      */
300     function grantRole(bytes32 role, address account) external;
301 
302     /**
303      * @dev Revokes `role` from `account`.
304      *
305      * If `account` had been granted `role`, emits a {RoleRevoked} event.
306      *
307      * Requirements:
308      *
309      * - the caller must have ``role``'s admin role.
310      */
311     function revokeRole(bytes32 role, address account) external;
312 
313     /**
314      * @dev Revokes `role` from the calling account.
315      *
316      * Roles are often managed via {grantRole} and {revokeRole}: this function's
317      * purpose is to provide a mechanism for accounts to lose their privileges
318      * if they are compromised (such as when a trusted device is misplaced).
319      *
320      * If the calling account had been granted `role`, emits a {RoleRevoked}
321      * event.
322      *
323      * Requirements:
324      *
325      * - the caller must be `account`.
326      */
327     function renounceRole(bytes32 role, address account) external;
328 }
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
331 
332 /**
333  * @dev Provides information about the current execution context, including the
334  * sender of the transaction and its data. While these are generally available
335  * via msg.sender and msg.data, they should not be accessed in such a direct
336  * manner, since when dealing with meta-transactions the account sending and
337  * paying for execution may not be the actual sender (as far as an application
338  * is concerned).
339  *
340  * This contract is only required for intermediate, library-like contracts.
341  */
342 abstract contract Context {
343     function _msgSender() internal view virtual returns (address) {
344         return msg.sender;
345     }
346 
347     function _msgData() internal view virtual returns (bytes calldata) {
348         return msg.data;
349     }
350 }
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
355 
356 /**
357  * @dev Standard math utilities missing in the Solidity language.
358  */
359 library Math {
360     enum Rounding {
361         Down, // Toward negative infinity
362         Up, // Toward infinity
363         Zero // Toward zero
364     }
365 
366     /**
367      * @dev Returns the largest of two numbers.
368      */
369     function max(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a > b ? a : b;
371     }
372 
373     /**
374      * @dev Returns the smallest of two numbers.
375      */
376     function min(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a < b ? a : b;
378     }
379 
380     /**
381      * @dev Returns the average of two numbers. The result is rounded towards
382      * zero.
383      */
384     function average(uint256 a, uint256 b) internal pure returns (uint256) {
385         // (a + b) / 2 can overflow.
386         return (a & b) + (a ^ b) / 2;
387     }
388 
389     /**
390      * @dev Returns the ceiling of the division of two numbers.
391      *
392      * This differs from standard division with `/` in that it rounds up instead
393      * of rounding down.
394      */
395     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
396         // (a + b - 1) / b can overflow on addition, so we distribute.
397         return a == 0 ? 0 : (a - 1) / b + 1;
398     }
399 
400     /**
401      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
402      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
403      * with further edits by Uniswap Labs also under MIT license.
404      */
405     function mulDiv(
406         uint256 x,
407         uint256 y,
408         uint256 denominator
409     ) internal pure returns (uint256 result) {
410         unchecked {
411             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
412             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
413             // variables such that product = prod1 * 2^256 + prod0.
414             uint256 prod0; // Least significant 256 bits of the product
415             uint256 prod1; // Most significant 256 bits of the product
416             assembly {
417                 let mm := mulmod(x, y, not(0))
418                 prod0 := mul(x, y)
419                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
420             }
421 
422             // Handle non-overflow cases, 256 by 256 division.
423             if (prod1 == 0) {
424                 return prod0 / denominator;
425             }
426 
427             // Make sure the result is less than 2^256. Also prevents denominator == 0.
428             require(denominator > prod1);
429 
430             ///////////////////////////////////////////////
431             // 512 by 256 division.
432             ///////////////////////////////////////////////
433 
434             // Make division exact by subtracting the remainder from [prod1 prod0].
435             uint256 remainder;
436             assembly {
437                 // Compute remainder using mulmod.
438                 remainder := mulmod(x, y, denominator)
439 
440                 // Subtract 256 bit number from 512 bit number.
441                 prod1 := sub(prod1, gt(remainder, prod0))
442                 prod0 := sub(prod0, remainder)
443             }
444 
445             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
446             // See https://cs.stackexchange.com/q/138556/92363.
447 
448             // Does not overflow because the denominator cannot be zero at this stage in the function.
449             uint256 twos = denominator & (~denominator + 1);
450             assembly {
451                 // Divide denominator by twos.
452                 denominator := div(denominator, twos)
453 
454                 // Divide [prod1 prod0] by twos.
455                 prod0 := div(prod0, twos)
456 
457                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
458                 twos := add(div(sub(0, twos), twos), 1)
459             }
460 
461             // Shift in bits from prod1 into prod0.
462             prod0 |= prod1 * twos;
463 
464             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
465             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
466             // four bits. That is, denominator * inv = 1 mod 2^4.
467             uint256 inverse = (3 * denominator) ^ 2;
468 
469             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
470             // in modular arithmetic, doubling the correct bits in each step.
471             inverse *= 2 - denominator * inverse; // inverse mod 2^8
472             inverse *= 2 - denominator * inverse; // inverse mod 2^16
473             inverse *= 2 - denominator * inverse; // inverse mod 2^32
474             inverse *= 2 - denominator * inverse; // inverse mod 2^64
475             inverse *= 2 - denominator * inverse; // inverse mod 2^128
476             inverse *= 2 - denominator * inverse; // inverse mod 2^256
477 
478             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
479             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
480             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
481             // is no longer required.
482             result = prod0 * inverse;
483             return result;
484         }
485     }
486 
487     /**
488      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
489      */
490     function mulDiv(
491         uint256 x,
492         uint256 y,
493         uint256 denominator,
494         Rounding rounding
495     ) internal pure returns (uint256) {
496         uint256 result = mulDiv(x, y, denominator);
497         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
498             result += 1;
499         }
500         return result;
501     }
502 
503     /**
504      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
505      *
506      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
507      */
508     function sqrt(uint256 a) internal pure returns (uint256) {
509         if (a == 0) {
510             return 0;
511         }
512 
513         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
514         //
515         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
516         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
517         //
518         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
519         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
520         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
521         //
522         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
523         uint256 result = 1 << (log2(a) >> 1);
524 
525         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
526         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
527         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
528         // into the expected uint128 result.
529         unchecked {
530             result = (result + a / result) >> 1;
531             result = (result + a / result) >> 1;
532             result = (result + a / result) >> 1;
533             result = (result + a / result) >> 1;
534             result = (result + a / result) >> 1;
535             result = (result + a / result) >> 1;
536             result = (result + a / result) >> 1;
537             return min(result, a / result);
538         }
539     }
540 
541     /**
542      * @notice Calculates sqrt(a), following the selected rounding direction.
543      */
544     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
545         unchecked {
546             uint256 result = sqrt(a);
547             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
548         }
549     }
550 
551     /**
552      * @dev Return the log in base 2, rounded down, of a positive value.
553      * Returns 0 if given 0.
554      */
555     function log2(uint256 value) internal pure returns (uint256) {
556         uint256 result = 0;
557         unchecked {
558             if (value >> 128 > 0) {
559                 value >>= 128;
560                 result += 128;
561             }
562             if (value >> 64 > 0) {
563                 value >>= 64;
564                 result += 64;
565             }
566             if (value >> 32 > 0) {
567                 value >>= 32;
568                 result += 32;
569             }
570             if (value >> 16 > 0) {
571                 value >>= 16;
572                 result += 16;
573             }
574             if (value >> 8 > 0) {
575                 value >>= 8;
576                 result += 8;
577             }
578             if (value >> 4 > 0) {
579                 value >>= 4;
580                 result += 4;
581             }
582             if (value >> 2 > 0) {
583                 value >>= 2;
584                 result += 2;
585             }
586             if (value >> 1 > 0) {
587                 result += 1;
588             }
589         }
590         return result;
591     }
592 
593     /**
594      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
595      * Returns 0 if given 0.
596      */
597     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
598         unchecked {
599             uint256 result = log2(value);
600             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
601         }
602     }
603 
604     /**
605      * @dev Return the log in base 10, rounded down, of a positive value.
606      * Returns 0 if given 0.
607      */
608     function log10(uint256 value) internal pure returns (uint256) {
609         uint256 result = 0;
610         unchecked {
611             if (value >= 10**64) {
612                 value /= 10**64;
613                 result += 64;
614             }
615             if (value >= 10**32) {
616                 value /= 10**32;
617                 result += 32;
618             }
619             if (value >= 10**16) {
620                 value /= 10**16;
621                 result += 16;
622             }
623             if (value >= 10**8) {
624                 value /= 10**8;
625                 result += 8;
626             }
627             if (value >= 10**4) {
628                 value /= 10**4;
629                 result += 4;
630             }
631             if (value >= 10**2) {
632                 value /= 10**2;
633                 result += 2;
634             }
635             if (value >= 10**1) {
636                 result += 1;
637             }
638         }
639         return result;
640     }
641 
642     /**
643      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
644      * Returns 0 if given 0.
645      */
646     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
647         unchecked {
648             uint256 result = log10(value);
649             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
650         }
651     }
652 
653     /**
654      * @dev Return the log in base 256, rounded down, of a positive value.
655      * Returns 0 if given 0.
656      *
657      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
658      */
659     function log256(uint256 value) internal pure returns (uint256) {
660         uint256 result = 0;
661         unchecked {
662             if (value >> 128 > 0) {
663                 value >>= 128;
664                 result += 16;
665             }
666             if (value >> 64 > 0) {
667                 value >>= 64;
668                 result += 8;
669             }
670             if (value >> 32 > 0) {
671                 value >>= 32;
672                 result += 4;
673             }
674             if (value >> 16 > 0) {
675                 value >>= 16;
676                 result += 2;
677             }
678             if (value >> 8 > 0) {
679                 result += 1;
680             }
681         }
682         return result;
683     }
684 
685     /**
686      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
687      * Returns 0 if given 0.
688      */
689     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
690         unchecked {
691             uint256 result = log256(value);
692             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
693         }
694     }
695 }
696 
697 /**
698  * @dev String operations.
699  */
700 library Strings {
701     bytes16 private constant _SYMBOLS = "0123456789abcdef";
702     uint8 private constant _ADDRESS_LENGTH = 20;
703 
704     /**
705      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
706      */
707     function toString(uint256 value) internal pure returns (string memory) {
708         unchecked {
709             uint256 length = Math.log10(value) + 1;
710             string memory buffer = new string(length);
711             uint256 ptr;
712             /// @solidity memory-safe-assembly
713             assembly {
714                 ptr := add(buffer, add(32, length))
715             }
716             while (true) {
717                 ptr--;
718                 /// @solidity memory-safe-assembly
719                 assembly {
720                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
721                 }
722                 value /= 10;
723                 if (value == 0) break;
724             }
725             return buffer;
726         }
727     }
728 
729     /**
730      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
731      */
732     function toHexString(uint256 value) internal pure returns (string memory) {
733         unchecked {
734             return toHexString(value, Math.log256(value) + 1);
735         }
736     }
737 
738     /**
739      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
740      */
741     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
742         bytes memory buffer = new bytes(2 * length + 2);
743         buffer[0] = "0";
744         buffer[1] = "x";
745         for (uint256 i = 2 * length + 1; i > 1; --i) {
746             buffer[i] = _SYMBOLS[value & 0xf];
747             value >>= 4;
748         }
749         require(value == 0, "Strings: hex length insufficient");
750         return string(buffer);
751     }
752 
753     /**
754      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
755      */
756     function toHexString(address addr) internal pure returns (string memory) {
757         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
758     }
759 }
760 
761 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
762 
763 /**
764  * @dev Implementation of the {IERC165} interface.
765  *
766  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
767  * for the additional interface id that will be supported. For example:
768  *
769  * ```solidity
770  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
772  * }
773  * ```
774  *
775  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
776  */
777 abstract contract ERC165 is IERC165 {
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 /**
787  * @dev Contract module that allows children to implement role-based access
788  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
789  * members except through off-chain means by accessing the contract event logs. Some
790  * applications may benefit from on-chain enumerability, for those cases see
791  * {AccessControlEnumerable}.
792  *
793  * Roles are referred to by their `bytes32` identifier. These should be exposed
794  * in the external API and be unique. The best way to achieve this is by
795  * using `public constant` hash digests:
796  *
797  * ```
798  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
799  * ```
800  *
801  * Roles can be used to represent a set of permissions. To restrict access to a
802  * function call, use {hasRole}:
803  *
804  * ```
805  * function foo() public {
806  *     require(hasRole(MY_ROLE, msg.sender));
807  *     ...
808  * }
809  * ```
810  *
811  * Roles can be granted and revoked dynamically via the {grantRole} and
812  * {revokeRole} functions. Each role has an associated admin role, and only
813  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
814  *
815  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
816  * that only accounts with this role will be able to grant or revoke other
817  * roles. More complex role relationships can be created by using
818  * {_setRoleAdmin}.
819  *
820  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
821  * grant and revoke this role. Extra precautions should be taken to secure
822  * accounts that have been granted it.
823  */
824 abstract contract AccessControl is Context, IAccessControl, ERC165 {
825     struct RoleData {
826         mapping(address => bool) members;
827         bytes32 adminRole;
828     }
829 
830     mapping(bytes32 => RoleData) private _roles;
831 
832     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
833 
834     /**
835      * @dev Modifier that checks that an account has a specific role. Reverts
836      * with a standardized message including the required role.
837      *
838      * The format of the revert reason is given by the following regular expression:
839      *
840      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
841      *
842      * _Available since v4.1._
843      */
844     modifier onlyRole(bytes32 role) {
845         _checkRole(role);
846         _;
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
853         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
854     }
855 
856     /**
857      * @dev Returns `true` if `account` has been granted `role`.
858      */
859     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
860         return _roles[role].members[account];
861     }
862 
863     /**
864      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
865      * Overriding this function changes the behavior of the {onlyRole} modifier.
866      *
867      * Format of the revert message is described in {_checkRole}.
868      *
869      * _Available since v4.6._
870      */
871     function _checkRole(bytes32 role) internal view virtual {
872         _checkRole(role, _msgSender());
873     }
874 
875     /**
876      * @dev Revert with a standard message if `account` is missing `role`.
877      *
878      * The format of the revert reason is given by the following regular expression:
879      *
880      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
881      */
882     function _checkRole(bytes32 role, address account) internal view virtual {
883         if (!hasRole(role, account)) {
884             revert(
885                 string(
886                     abi.encodePacked(
887                         "AccessControl: account ",
888                         Strings.toHexString(account),
889                         " is missing role ",
890                         Strings.toHexString(uint256(role), 32)
891                     )
892                 )
893             );
894         }
895     }
896 
897     /**
898      * @dev Returns the admin role that controls `role`. See {grantRole} and
899      * {revokeRole}.
900      *
901      * To change a role's admin, use {_setRoleAdmin}.
902      */
903     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
904         return _roles[role].adminRole;
905     }
906 
907     /**
908      * @dev Grants `role` to `account`.
909      *
910      * If `account` had not been already granted `role`, emits a {RoleGranted}
911      * event.
912      *
913      * Requirements:
914      *
915      * - the caller must have ``role``'s admin role.
916      *
917      * May emit a {RoleGranted} event.
918      */
919     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
920         _grantRole(role, account);
921     }
922 
923     /**
924      * @dev Revokes `role` from `account`.
925      *
926      * If `account` had been granted `role`, emits a {RoleRevoked} event.
927      *
928      * Requirements:
929      *
930      * - the caller must have ``role``'s admin role.
931      *
932      * May emit a {RoleRevoked} event.
933      */
934     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
935         _revokeRole(role, account);
936     }
937 
938     /**
939      * @dev Revokes `role` from the calling account.
940      *
941      * Roles are often managed via {grantRole} and {revokeRole}: this function's
942      * purpose is to provide a mechanism for accounts to lose their privileges
943      * if they are compromised (such as when a trusted device is misplaced).
944      *
945      * If the calling account had been revoked `role`, emits a {RoleRevoked}
946      * event.
947      *
948      * Requirements:
949      *
950      * - the caller must be `account`.
951      *
952      * May emit a {RoleRevoked} event.
953      */
954     function renounceRole(bytes32 role, address account) public virtual override {
955         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
956 
957         _revokeRole(role, account);
958     }
959 
960     /**
961      * @dev Grants `role` to `account`.
962      *
963      * If `account` had not been already granted `role`, emits a {RoleGranted}
964      * event. Note that unlike {grantRole}, this function doesn't perform any
965      * checks on the calling account.
966      *
967      * May emit a {RoleGranted} event.
968      *
969      * [WARNING]
970      * ====
971      * This function should only be called from the constructor when setting
972      * up the initial roles for the system.
973      *
974      * Using this function in any other way is effectively circumventing the admin
975      * system imposed by {AccessControl}.
976      * ====
977      *
978      * NOTE: This function is deprecated in favor of {_grantRole}.
979      */
980     function _setupRole(bytes32 role, address account) internal virtual {
981         _grantRole(role, account);
982     }
983 
984     /**
985      * @dev Sets `adminRole` as ``role``'s admin role.
986      *
987      * Emits a {RoleAdminChanged} event.
988      */
989     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
990         bytes32 previousAdminRole = getRoleAdmin(role);
991         _roles[role].adminRole = adminRole;
992         emit RoleAdminChanged(role, previousAdminRole, adminRole);
993     }
994 
995     /**
996      * @dev Grants `role` to `account`.
997      *
998      * Internal function without access restriction.
999      *
1000      * May emit a {RoleGranted} event.
1001      */
1002     function _grantRole(bytes32 role, address account) internal virtual {
1003         if (!hasRole(role, account)) {
1004             _roles[role].members[account] = true;
1005             emit RoleGranted(role, account, _msgSender());
1006         }
1007     }
1008 
1009     /**
1010      * @dev Revokes `role` from `account`.
1011      *
1012      * Internal function without access restriction.
1013      *
1014      * May emit a {RoleRevoked} event.
1015      */
1016     function _revokeRole(bytes32 role, address account) internal virtual {
1017         if (hasRole(role, account)) {
1018             _roles[role].members[account] = false;
1019             emit RoleRevoked(role, account, _msgSender());
1020         }
1021     }
1022 }
1023 
1024 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1025 
1026 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1027 
1028 /**
1029  * @title ERC721 token receiver interface
1030  * @dev Interface for any contract that wants to support safeTransfers
1031  * from ERC721 asset contracts.
1032  */
1033 interface IERC721Receiver {
1034     /**
1035      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1036      * by `operator` from `from`, this function is called.
1037      *
1038      * It must return its Solidity selector to confirm the token transfer.
1039      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1040      *
1041      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1042      */
1043     function onERC721Received(
1044         address operator,
1045         address from,
1046         uint256 tokenId,
1047         bytes calldata data
1048     ) external returns (bytes4);
1049 }
1050 
1051 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1052 
1053 /**
1054  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1055  * @dev See https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 interface IERC721Metadata is IERC721 {
1058     /**
1059      * @dev Returns the token collection name.
1060      */
1061     function name() external view returns (string memory);
1062 
1063     /**
1064      * @dev Returns the token collection symbol.
1065      */
1066     function symbol() external view returns (string memory);
1067 
1068     /**
1069      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1070      */
1071     function tokenURI(uint256 tokenId) external view returns (string memory);
1072 }
1073 
1074 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1075 
1076 /**
1077  * @dev Collection of functions related to the address type
1078  */
1079 library Address {
1080     /**
1081      * @dev Returns true if `account` is a contract.
1082      *
1083      * [IMPORTANT]
1084      * ====
1085      * It is unsafe to assume that an address for which this function returns
1086      * false is an externally-owned account (EOA) and not a contract.
1087      *
1088      * Among others, `isContract` will return false for the following
1089      * types of addresses:
1090      *
1091      *  - an externally-owned account
1092      *  - a contract in construction
1093      *  - an address where a contract will be created
1094      *  - an address where a contract lived, but was destroyed
1095      * ====
1096      *
1097      * [IMPORTANT]
1098      * ====
1099      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1100      *
1101      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1102      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1103      * constructor.
1104      * ====
1105      */
1106     function isContract(address account) internal view returns (bool) {
1107         // This method relies on extcodesize/address.code.length, which returns 0
1108         // for contracts in construction, since the code is only stored at the end
1109         // of the constructor execution.
1110 
1111         return account.code.length > 0;
1112     }
1113 
1114     /**
1115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1116      * `recipient`, forwarding all available gas and reverting on errors.
1117      *
1118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1120      * imposed by `transfer`, making them unable to receive funds via
1121      * `transfer`. {sendValue} removes this limitation.
1122      *
1123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1124      *
1125      * IMPORTANT: because control is transferred to `recipient`, care must be
1126      * taken to not create reentrancy vulnerabilities. Consider using
1127      * {ReentrancyGuard} or the
1128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1129      */
1130     function sendValue(address payable recipient, uint256 amount) internal {
1131         require(address(this).balance >= amount, "Address: insufficient balance");
1132 
1133         (bool success, ) = recipient.call{value: amount}("");
1134         require(success, "Address: unable to send value, recipient may have reverted");
1135     }
1136 
1137     /**
1138      * @dev Performs a Solidity function call using a low level `call`. A
1139      * plain `call` is an unsafe replacement for a function call: use this
1140      * function instead.
1141      *
1142      * If `target` reverts with a revert reason, it is bubbled up by this
1143      * function (like regular Solidity function calls).
1144      *
1145      * Returns the raw returned data. To convert to the expected return value,
1146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1147      *
1148      * Requirements:
1149      *
1150      * - `target` must be a contract.
1151      * - calling `target` with `data` must not revert.
1152      *
1153      * _Available since v3.1._
1154      */
1155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1156         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1157     }
1158 
1159     /**
1160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1161      * `errorMessage` as a fallback revert reason when `target` reverts.
1162      *
1163      * _Available since v3.1._
1164      */
1165     function functionCall(
1166         address target,
1167         bytes memory data,
1168         string memory errorMessage
1169     ) internal returns (bytes memory) {
1170         return functionCallWithValue(target, data, 0, errorMessage);
1171     }
1172 
1173     /**
1174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1175      * but also transferring `value` wei to `target`.
1176      *
1177      * Requirements:
1178      *
1179      * - the calling contract must have an ETH balance of at least `value`.
1180      * - the called Solidity function must be `payable`.
1181      *
1182      * _Available since v3.1._
1183      */
1184     function functionCallWithValue(
1185         address target,
1186         bytes memory data,
1187         uint256 value
1188     ) internal returns (bytes memory) {
1189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1190     }
1191 
1192     /**
1193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1194      * with `errorMessage` as a fallback revert reason when `target` reverts.
1195      *
1196      * _Available since v3.1._
1197      */
1198     function functionCallWithValue(
1199         address target,
1200         bytes memory data,
1201         uint256 value,
1202         string memory errorMessage
1203     ) internal returns (bytes memory) {
1204         require(address(this).balance >= value, "Address: insufficient balance for call");
1205         (bool success, bytes memory returndata) = target.call{value: value}(data);
1206         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1207     }
1208 
1209     /**
1210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1211      * but performing a static call.
1212      *
1213      * _Available since v3.3._
1214      */
1215     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1216         return functionStaticCall(target, data, "Address: low-level static call failed");
1217     }
1218 
1219     /**
1220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1221      * but performing a static call.
1222      *
1223      * _Available since v3.3._
1224      */
1225     function functionStaticCall(
1226         address target,
1227         bytes memory data,
1228         string memory errorMessage
1229     ) internal view returns (bytes memory) {
1230         (bool success, bytes memory returndata) = target.staticcall(data);
1231         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1232     }
1233 
1234     /**
1235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1236      * but performing a delegate call.
1237      *
1238      * _Available since v3.4._
1239      */
1240     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1241         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1242     }
1243 
1244     /**
1245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1246      * but performing a delegate call.
1247      *
1248      * _Available since v3.4._
1249      */
1250     function functionDelegateCall(
1251         address target,
1252         bytes memory data,
1253         string memory errorMessage
1254     ) internal returns (bytes memory) {
1255         (bool success, bytes memory returndata) = target.delegatecall(data);
1256         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1257     }
1258 
1259     /**
1260      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1261      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1262      *
1263      * _Available since v4.8._
1264      */
1265     function verifyCallResultFromTarget(
1266         address target,
1267         bool success,
1268         bytes memory returndata,
1269         string memory errorMessage
1270     ) internal view returns (bytes memory) {
1271         if (success) {
1272             if (returndata.length == 0) {
1273                 // only check isContract if the call was successful and the return data is empty
1274                 // otherwise we already know that it was a contract
1275                 require(isContract(target), "Address: call to non-contract");
1276             }
1277             return returndata;
1278         } else {
1279             _revert(returndata, errorMessage);
1280         }
1281     }
1282 
1283     /**
1284      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1285      * revert reason or using the provided one.
1286      *
1287      * _Available since v4.3._
1288      */
1289     function verifyCallResult(
1290         bool success,
1291         bytes memory returndata,
1292         string memory errorMessage
1293     ) internal pure returns (bytes memory) {
1294         if (success) {
1295             return returndata;
1296         } else {
1297             _revert(returndata, errorMessage);
1298         }
1299     }
1300 
1301     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1302         // Look for revert reason and bubble it up if present
1303         if (returndata.length > 0) {
1304             // The easiest way to bubble the revert reason is using memory via assembly
1305             /// @solidity memory-safe-assembly
1306             assembly {
1307                 let returndata_size := mload(returndata)
1308                 revert(add(32, returndata), returndata_size)
1309             }
1310         } else {
1311             revert(errorMessage);
1312         }
1313     }
1314 }
1315 
1316 /**
1317  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1318  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1319  * {ERC721Enumerable}.
1320  */
1321 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1322     using Address for address;
1323     using Strings for uint256;
1324 
1325     // Token name
1326     string private _name;
1327 
1328     // Token symbol
1329     string private _symbol;
1330 
1331     // Mapping from token ID to owner address
1332     mapping(uint256 => address) private _owners;
1333 
1334     // Mapping owner address to token count
1335     mapping(address => uint256) private _balances;
1336 
1337     // Mapping from token ID to approved address
1338     mapping(uint256 => address) private _tokenApprovals;
1339 
1340     // Mapping from owner to operator approvals
1341     mapping(address => mapping(address => bool)) private _operatorApprovals;
1342 
1343     /**
1344      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1345      */
1346     constructor(string memory name_, string memory symbol_) {
1347         _name = name_;
1348         _symbol = symbol_;
1349     }
1350 
1351     /**
1352      * @dev See {IERC165-supportsInterface}.
1353      */
1354     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1355         return
1356             interfaceId == type(IERC721).interfaceId ||
1357             interfaceId == type(IERC721Metadata).interfaceId ||
1358             super.supportsInterface(interfaceId);
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-balanceOf}.
1363      */
1364     function balanceOf(address owner) public view virtual override returns (uint256) {
1365         require(owner != address(0), "ERC721: address zero is not a valid owner");
1366         return _balances[owner];
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-ownerOf}.
1371      */
1372     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1373         address owner = _ownerOf(tokenId);
1374         require(owner != address(0), "ERC721: invalid token ID");
1375         return owner;
1376     }
1377 
1378     /**
1379      * @dev See {IERC721Metadata-name}.
1380      */
1381     function name() public view virtual override returns (string memory) {
1382         return _name;
1383     }
1384 
1385     /**
1386      * @dev See {IERC721Metadata-symbol}.
1387      */
1388     function symbol() public view virtual override returns (string memory) {
1389         return _symbol;
1390     }
1391 
1392     /**
1393      * @dev See {IERC721Metadata-tokenURI}.
1394      */
1395     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1396         _requireMinted(tokenId);
1397 
1398         string memory baseURI = _baseURI();
1399         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1400     }
1401 
1402     /**
1403      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1404      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1405      * by default, can be overridden in child contracts.
1406      */
1407     function _baseURI() internal view virtual returns (string memory) {
1408         return "";
1409     }
1410 
1411     /**
1412      * @dev See {IERC721-approve}.
1413      */
1414     function approve(address to, uint256 tokenId) public virtual override {
1415         address owner = ERC721.ownerOf(tokenId);
1416         require(to != owner, "ERC721: approval to current owner");
1417 
1418         require(
1419             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1420             "ERC721: approve caller is not token owner or approved for all"
1421         );
1422 
1423         _approve(to, tokenId);
1424     }
1425 
1426     /**
1427      * @dev See {IERC721-getApproved}.
1428      */
1429     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1430         _requireMinted(tokenId);
1431 
1432         return _tokenApprovals[tokenId];
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-setApprovalForAll}.
1437      */
1438     function setApprovalForAll(address operator, bool approved) public virtual override {
1439         _setApprovalForAll(_msgSender(), operator, approved);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-isApprovedForAll}.
1444      */
1445     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1446         return _operatorApprovals[owner][operator];
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-transferFrom}.
1451      */
1452     function transferFrom(
1453         address from,
1454         address to,
1455         uint256 tokenId
1456     ) public virtual override {
1457         //solhint-disable-next-line max-line-length
1458         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1459 
1460         _transfer(from, to, tokenId);
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-safeTransferFrom}.
1465      */
1466     function safeTransferFrom(
1467         address from,
1468         address to,
1469         uint256 tokenId
1470     ) public virtual override {
1471         safeTransferFrom(from, to, tokenId, "");
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-safeTransferFrom}.
1476      */
1477     function safeTransferFrom(
1478         address from,
1479         address to,
1480         uint256 tokenId,
1481         bytes memory data
1482     ) public virtual override {
1483         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1484         _safeTransfer(from, to, tokenId, data);
1485     }
1486 
1487     /**
1488      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1489      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1490      *
1491      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1492      *
1493      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1494      * implement alternative mechanisms to perform token transfer, such as signature-based.
1495      *
1496      * Requirements:
1497      *
1498      * - `from` cannot be the zero address.
1499      * - `to` cannot be the zero address.
1500      * - `tokenId` token must exist and be owned by `from`.
1501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function _safeTransfer(
1506         address from,
1507         address to,
1508         uint256 tokenId,
1509         bytes memory data
1510     ) internal virtual {
1511         _transfer(from, to, tokenId);
1512         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1513     }
1514 
1515     /**
1516      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1517      */
1518     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1519         return _owners[tokenId];
1520     }
1521 
1522     /**
1523      * @dev Returns whether `tokenId` exists.
1524      *
1525      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1526      *
1527      * Tokens start existing when they are minted (`_mint`),
1528      * and stop existing when they are burned (`_burn`).
1529      */
1530     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1531         return _ownerOf(tokenId) != address(0);
1532     }
1533 
1534     /**
1535      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1536      *
1537      * Requirements:
1538      *
1539      * - `tokenId` must exist.
1540      */
1541     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1542         address owner = ERC721.ownerOf(tokenId);
1543         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1544     }
1545 
1546     /**
1547      * @dev Safely mints `tokenId` and transfers it to `to`.
1548      *
1549      * Requirements:
1550      *
1551      * - `tokenId` must not exist.
1552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1553      *
1554      * Emits a {Transfer} event.
1555      */
1556     function _safeMint(address to, uint256 tokenId) internal virtual {
1557         _safeMint(to, tokenId, "");
1558     }
1559 
1560     /**
1561      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1562      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1563      */
1564     function _safeMint(
1565         address to,
1566         uint256 tokenId,
1567         bytes memory data
1568     ) internal virtual {
1569         _mint(to, tokenId);
1570         require(
1571             _checkOnERC721Received(address(0), to, tokenId, data),
1572             "ERC721: transfer to non ERC721Receiver implementer"
1573         );
1574     }
1575 
1576     /**
1577      * @dev Mints `tokenId` and transfers it to `to`.
1578      *
1579      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must not exist.
1584      * - `to` cannot be the zero address.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _mint(address to, uint256 tokenId) internal virtual {
1589         require(to != address(0), "ERC721: mint to the zero address");
1590         require(!_exists(tokenId), "ERC721: token already minted");
1591 
1592         _beforeTokenTransfer(address(0), to, tokenId, 1);
1593 
1594         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1595         require(!_exists(tokenId), "ERC721: token already minted");
1596 
1597         unchecked {
1598             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1599             // Given that tokens are minted one by one, it is impossible in practice that
1600             // this ever happens. Might change if we allow batch minting.
1601             // The ERC fails to describe this case.
1602             _balances[to] += 1;
1603         }
1604 
1605         _owners[tokenId] = to;
1606 
1607         emit Transfer(address(0), to, tokenId);
1608 
1609         _afterTokenTransfer(address(0), to, tokenId, 1);
1610     }
1611 
1612     /**
1613      * @dev Destroys `tokenId`.
1614      * The approval is cleared when the token is burned.
1615      * This is an internal function that does not check if the sender is authorized to operate on the token.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function _burn(uint256 tokenId) internal virtual {
1624         address owner = ERC721.ownerOf(tokenId);
1625 
1626         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1627 
1628         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1629         owner = ERC721.ownerOf(tokenId);
1630 
1631         // Clear approvals
1632         delete _tokenApprovals[tokenId];
1633 
1634         unchecked {
1635             // Cannot overflow, as that would require more tokens to be burned/transferred
1636             // out than the owner initially received through minting and transferring in.
1637             _balances[owner] -= 1;
1638         }
1639         delete _owners[tokenId];
1640 
1641         emit Transfer(owner, address(0), tokenId);
1642 
1643         _afterTokenTransfer(owner, address(0), tokenId, 1);
1644     }
1645 
1646     /**
1647      * @dev Transfers `tokenId` from `from` to `to`.
1648      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1649      *
1650      * Requirements:
1651      *
1652      * - `to` cannot be the zero address.
1653      * - `tokenId` token must be owned by `from`.
1654      *
1655      * Emits a {Transfer} event.
1656      */
1657     function _transfer(
1658         address from,
1659         address to,
1660         uint256 tokenId
1661     ) internal virtual {
1662         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1663         require(to != address(0), "ERC721: transfer to the zero address");
1664 
1665         _beforeTokenTransfer(from, to, tokenId, 1);
1666 
1667         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1668         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1669 
1670         // Clear approvals from the previous owner
1671         delete _tokenApprovals[tokenId];
1672 
1673         unchecked {
1674             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1675             // `from`'s balance is the number of token held, which is at least one before the current
1676             // transfer.
1677             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1678             // all 2**256 token ids to be minted, which in practice is impossible.
1679             _balances[from] -= 1;
1680             _balances[to] += 1;
1681         }
1682         _owners[tokenId] = to;
1683 
1684         emit Transfer(from, to, tokenId);
1685 
1686         _afterTokenTransfer(from, to, tokenId, 1);
1687     }
1688 
1689     /**
1690      * @dev Approve `to` to operate on `tokenId`
1691      *
1692      * Emits an {Approval} event.
1693      */
1694     function _approve(address to, uint256 tokenId) internal virtual {
1695         _tokenApprovals[tokenId] = to;
1696         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Approve `operator` to operate on all of `owner` tokens
1701      *
1702      * Emits an {ApprovalForAll} event.
1703      */
1704     function _setApprovalForAll(
1705         address owner,
1706         address operator,
1707         bool approved
1708     ) internal virtual {
1709         require(owner != operator, "ERC721: approve to caller");
1710         _operatorApprovals[owner][operator] = approved;
1711         emit ApprovalForAll(owner, operator, approved);
1712     }
1713 
1714     /**
1715      * @dev Reverts if the `tokenId` has not been minted yet.
1716      */
1717     function _requireMinted(uint256 tokenId) internal view virtual {
1718         require(_exists(tokenId), "ERC721: invalid token ID");
1719     }
1720 
1721     /**
1722      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1723      * The call is not executed if the target address is not a contract.
1724      *
1725      * @param from address representing the previous owner of the given token ID
1726      * @param to target address that will receive the tokens
1727      * @param tokenId uint256 ID of the token to be transferred
1728      * @param data bytes optional data to send along with the call
1729      * @return bool whether the call correctly returned the expected magic value
1730      */
1731     function _checkOnERC721Received(
1732         address from,
1733         address to,
1734         uint256 tokenId,
1735         bytes memory data
1736     ) private returns (bool) {
1737         if (to.isContract()) {
1738             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1739                 return retval == IERC721Receiver.onERC721Received.selector;
1740             } catch (bytes memory reason) {
1741                 if (reason.length == 0) {
1742                     revert("ERC721: transfer to non ERC721Receiver implementer");
1743                 } else {
1744                     /// @solidity memory-safe-assembly
1745                     assembly {
1746                         revert(add(32, reason), mload(reason))
1747                     }
1748                 }
1749             }
1750         } else {
1751             return true;
1752         }
1753     }
1754 
1755     /**
1756      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1757      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1758      *
1759      * Calling conditions:
1760      *
1761      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1762      * - When `from` is zero, the tokens will be minted for `to`.
1763      * - When `to` is zero, ``from``'s tokens will be burned.
1764      * - `from` and `to` are never both zero.
1765      * - `batchSize` is non-zero.
1766      *
1767      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1768      */
1769     function _beforeTokenTransfer(
1770         address from,
1771         address to,
1772         uint256, /* firstTokenId */
1773         uint256 batchSize
1774     ) internal virtual {
1775         if (batchSize > 1) {
1776             if (from != address(0)) {
1777                 _balances[from] -= batchSize;
1778             }
1779             if (to != address(0)) {
1780                 _balances[to] += batchSize;
1781             }
1782         }
1783     }
1784 
1785     /**
1786      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1787      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1788      *
1789      * Calling conditions:
1790      *
1791      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1792      * - When `from` is zero, the tokens were minted for `to`.
1793      * - When `to` is zero, ``from``'s tokens were burned.
1794      * - `from` and `to` are never both zero.
1795      * - `batchSize` is non-zero.
1796      *
1797      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1798      */
1799     function _afterTokenTransfer(
1800         address from,
1801         address to,
1802         uint256 firstTokenId,
1803         uint256 batchSize
1804     ) internal virtual {}
1805 }
1806 
1807 // contracts/Messages.sol
1808 
1809 interface IWormhole {
1810     struct GuardianSet {
1811         address[] keys;
1812         uint32 expirationTime;
1813     }
1814 
1815     struct Signature {
1816         bytes32 r;
1817         bytes32 s;
1818         uint8 v;
1819         uint8 guardianIndex;
1820     }
1821 
1822     struct VM {
1823         uint8 version;
1824         uint32 timestamp;
1825         uint32 nonce;
1826         uint16 emitterChainId;
1827         bytes32 emitterAddress;
1828         uint64 sequence;
1829         uint8 consistencyLevel;
1830         bytes payload;
1831 
1832         uint32 guardianSetIndex;
1833         Signature[] signatures;
1834 
1835         bytes32 hash;
1836     }
1837 
1838     struct ContractUpgrade {
1839         bytes32 module;
1840         uint8 action;
1841         uint16 chain;
1842 
1843         address newContract;
1844     }
1845 
1846     struct GuardianSetUpgrade {
1847         bytes32 module;
1848         uint8 action;
1849         uint16 chain;
1850 
1851         GuardianSet newGuardianSet;
1852         uint32 newGuardianSetIndex;
1853     }
1854 
1855     struct SetMessageFee {
1856         bytes32 module;
1857         uint8 action;
1858         uint16 chain;
1859 
1860         uint256 messageFee;
1861     }
1862 
1863     struct TransferFees {
1864         bytes32 module;
1865         uint8 action;
1866         uint16 chain;
1867 
1868         uint256 amount;
1869         bytes32 recipient;
1870     }
1871 
1872     struct RecoverChainId {
1873         bytes32 module;
1874         uint8 action;
1875 
1876         uint256 evmChainId;
1877         uint16 newChainId;
1878     }
1879 
1880     event LogMessagePublished(address indexed sender, uint64 sequence, uint32 nonce, bytes payload, uint8 consistencyLevel);
1881     event ContractUpgraded(address indexed oldContract, address indexed newContract);
1882     event GuardianSetAdded(uint32 indexed index);
1883 
1884     function publishMessage(
1885         uint32 nonce,
1886         bytes memory payload,
1887         uint8 consistencyLevel
1888     ) external payable returns (uint64 sequence);
1889 
1890     function initialize() external;
1891 
1892     function parseAndVerifyVM(bytes calldata encodedVM) external view returns (VM memory vm, bool valid, string memory reason);
1893 
1894     function verifyVM(VM memory vm) external view returns (bool valid, string memory reason);
1895 
1896     function verifySignatures(bytes32 hash, Signature[] memory signatures, GuardianSet memory guardianSet) external pure returns (bool valid, string memory reason);
1897 
1898     function parseVM(bytes memory encodedVM) external pure returns (VM memory vm);
1899 
1900     function quorum(uint numGuardians) external pure returns (uint numSignaturesRequiredForQuorum);
1901 
1902     function getGuardianSet(uint32 index) external view returns (GuardianSet memory);
1903 
1904     function getCurrentGuardianSetIndex() external view returns (uint32);
1905 
1906     function getGuardianSetExpiry() external view returns (uint32);
1907 
1908     function governanceActionIsConsumed(bytes32 hash) external view returns (bool);
1909 
1910     function isInitialized(address impl) external view returns (bool);
1911 
1912     function chainId() external view returns (uint16);
1913 
1914     function isFork() external view returns (bool);
1915 
1916     function governanceChainId() external view returns (uint16);
1917 
1918     function governanceContract() external view returns (bytes32);
1919 
1920     function messageFee() external view returns (uint256);
1921 
1922     function evmChainId() external view returns (uint256);
1923 
1924     function nextSequence(address emitter) external view returns (uint64);
1925 
1926     function parseContractUpgrade(bytes memory encodedUpgrade) external pure returns (ContractUpgrade memory cu);
1927 
1928     function parseGuardianSetUpgrade(bytes memory encodedUpgrade) external pure returns (GuardianSetUpgrade memory gsu);
1929 
1930     function parseSetMessageFee(bytes memory encodedSetMessageFee) external pure returns (SetMessageFee memory smf);
1931 
1932     function parseTransferFees(bytes memory encodedTransferFees) external pure returns (TransferFees memory tf);
1933 
1934     function parseRecoverChainId(bytes memory encodedRecoverChainId) external pure returns (RecoverChainId memory rci);
1935 
1936     function submitContractUpgrade(bytes memory _vm) external;
1937 
1938     function submitSetMessageFee(bytes memory _vm) external;
1939 
1940     function submitNewGuardianSet(bytes memory _vm) external;
1941 
1942     function submitTransferFees(bytes memory _vm) external;
1943 
1944     function submitRecoverChainId(bytes memory _vm) external;
1945 }
1946 
1947 // contracts/Bridge.sol
1948 
1949 // contracts/Bridge.sol
1950 
1951 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1952 
1953 /**
1954  * @dev Interface of the ERC20 standard as defined in the EIP.
1955  */
1956 interface IERC20 {
1957     /**
1958      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1959      * another (`to`).
1960      *
1961      * Note that `value` may be zero.
1962      */
1963     event Transfer(address indexed from, address indexed to, uint256 value);
1964 
1965     /**
1966      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1967      * a call to {approve}. `value` is the new allowance.
1968      */
1969     event Approval(address indexed owner, address indexed spender, uint256 value);
1970 
1971     /**
1972      * @dev Returns the amount of tokens in existence.
1973      */
1974     function totalSupply() external view returns (uint256);
1975 
1976     /**
1977      * @dev Returns the amount of tokens owned by `account`.
1978      */
1979     function balanceOf(address account) external view returns (uint256);
1980 
1981     /**
1982      * @dev Moves `amount` tokens from the caller's account to `to`.
1983      *
1984      * Returns a boolean value indicating whether the operation succeeded.
1985      *
1986      * Emits a {Transfer} event.
1987      */
1988     function transfer(address to, uint256 amount) external returns (bool);
1989 
1990     /**
1991      * @dev Returns the remaining number of tokens that `spender` will be
1992      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1993      * zero by default.
1994      *
1995      * This value changes when {approve} or {transferFrom} are called.
1996      */
1997     function allowance(address owner, address spender) external view returns (uint256);
1998 
1999     /**
2000      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2001      *
2002      * Returns a boolean value indicating whether the operation succeeded.
2003      *
2004      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2005      * that someone may use both the old and the new allowance by unfortunate
2006      * transaction ordering. One possible solution to mitigate this race
2007      * condition is to first reduce the spender's allowance to 0 and set the
2008      * desired value afterwards:
2009      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2010      *
2011      * Emits an {Approval} event.
2012      */
2013     function approve(address spender, uint256 amount) external returns (bool);
2014 
2015     /**
2016      * @dev Moves `amount` tokens from `from` to `to` using the
2017      * allowance mechanism. `amount` is then deducted from the caller's
2018      * allowance.
2019      *
2020      * Returns a boolean value indicating whether the operation succeeded.
2021      *
2022      * Emits a {Transfer} event.
2023      */
2024     function transferFrom(
2025         address from,
2026         address to,
2027         uint256 amount
2028     ) external returns (bool);
2029 }
2030 
2031 interface IWETH is IERC20 {
2032     function deposit() external payable;
2033     function withdraw(uint amount) external;
2034 }
2035 
2036 interface ITokenBridge {
2037     struct Transfer {
2038         uint8 payloadID;
2039         uint256 amount;
2040         bytes32 tokenAddress;
2041         uint16 tokenChain;
2042         bytes32 to;
2043         uint16 toChain;
2044         uint256 fee;
2045     }
2046 
2047     struct TransferWithPayload {
2048         uint8 payloadID;
2049         uint256 amount;
2050         bytes32 tokenAddress;
2051         uint16 tokenChain;
2052         bytes32 to;
2053         uint16 toChain;
2054         bytes32 fromAddress;
2055         bytes payload;
2056     }
2057 
2058     struct AssetMeta {
2059         uint8 payloadID;
2060         bytes32 tokenAddress;
2061         uint16 tokenChain;
2062         uint8 decimals;
2063         bytes32 symbol;
2064         bytes32 name;
2065     }
2066 
2067     struct RegisterChain {
2068         bytes32 module;
2069         uint8 action;
2070         uint16 chainId;
2071 
2072         uint16 emitterChainID;
2073         bytes32 emitterAddress;
2074     }
2075 
2076      struct UpgradeContract {
2077         bytes32 module;
2078         uint8 action;
2079         uint16 chainId;
2080 
2081         bytes32 newContract;
2082     }
2083 
2084     struct RecoverChainId {
2085         bytes32 module;
2086         uint8 action;
2087 
2088         uint256 evmChainId;
2089         uint16 newChainId;
2090     }
2091 
2092     event ContractUpgraded(address indexed oldContract, address indexed newContract);
2093 
2094     function _parseTransferCommon(bytes memory encoded) external pure returns (Transfer memory transfer);
2095 
2096     function attestToken(address tokenAddress, uint32 nonce) external payable returns (uint64 sequence);
2097 
2098     function wrapAndTransferETH(uint16 recipientChain, bytes32 recipient, uint256 arbiterFee, uint32 nonce) external payable returns (uint64 sequence);
2099 
2100     function wrapAndTransferETHWithPayload(uint16 recipientChain, bytes32 recipient, uint32 nonce, bytes memory payload) external payable returns (uint64 sequence);
2101 
2102     function transferTokens(address token, uint256 amount, uint16 recipientChain, bytes32 recipient, uint256 arbiterFee, uint32 nonce) external payable returns (uint64 sequence);
2103 
2104     function transferTokensWithPayload(address token, uint256 amount, uint16 recipientChain, bytes32 recipient, uint32 nonce, bytes memory payload) external payable returns (uint64 sequence);
2105 
2106     function updateWrapped(bytes memory encodedVm) external returns (address token);
2107 
2108     function createWrapped(bytes memory encodedVm) external returns (address token);
2109 
2110     function completeTransferWithPayload(bytes memory encodedVm) external returns (bytes memory);
2111 
2112     function completeTransferAndUnwrapETHWithPayload(bytes memory encodedVm) external returns (bytes memory);
2113 
2114     function completeTransfer(bytes memory encodedVm) external;
2115 
2116     function completeTransferAndUnwrapETH(bytes memory encodedVm) external;
2117 
2118     function encodeAssetMeta(AssetMeta memory meta) external pure returns (bytes memory encoded);
2119 
2120     function encodeTransfer(Transfer memory transfer) external pure returns (bytes memory encoded);
2121 
2122     function encodeTransferWithPayload(TransferWithPayload memory transfer) external pure returns (bytes memory encoded);
2123 
2124     function parsePayloadID(bytes memory encoded) external pure returns (uint8 payloadID);
2125 
2126     function parseAssetMeta(bytes memory encoded) external pure returns (AssetMeta memory meta);
2127 
2128     function parseTransfer(bytes memory encoded) external pure returns (Transfer memory transfer);
2129 
2130     function parseTransferWithPayload(bytes memory encoded) external pure returns (TransferWithPayload memory transfer);
2131 
2132     function governanceActionIsConsumed(bytes32 hash) external view returns (bool);
2133 
2134     function isInitialized(address impl) external view returns (bool);
2135 
2136     function isTransferCompleted(bytes32 hash) external view returns (bool);
2137 
2138     function wormhole() external view returns (IWormhole);
2139 
2140     function chainId() external view returns (uint16);
2141 
2142     function evmChainId() external view returns (uint256);
2143 
2144     function isFork() external view returns (bool);
2145 
2146     function governanceChainId() external view returns (uint16);
2147 
2148     function governanceContract() external view returns (bytes32);
2149 
2150     function wrappedAsset(uint16 tokenChainId, bytes32 tokenAddress) external view returns (address);
2151 
2152     function bridgeContracts(uint16 chainId_) external view returns (bytes32);
2153 
2154     function tokenImplementation() external view returns (address);
2155 
2156     function WETH() external view returns (IWETH);
2157 
2158     function outstandingBridged(address token) external view returns (uint256);
2159 
2160     function isWrappedAsset(address token) external view returns (bool);
2161 
2162     function finality() external view returns (uint8);
2163 
2164     function implementation() external view returns (address);
2165 
2166     function initialize() external;
2167 
2168     function registerChain(bytes memory encodedVM) external;
2169 
2170     function upgrade(bytes memory encodedVM) external;
2171 
2172     function submitRecoverChainId(bytes memory encodedVM) external;
2173 
2174     function parseRegisterChain(bytes memory encoded) external pure returns (RegisterChain memory chain);
2175 
2176     function parseUpgrade(bytes memory encoded) external pure returns (UpgradeContract memory chain);
2177 
2178     function parseRecoverChainId(bytes memory encodedRecoverChainId) external pure returns (RecoverChainId memory rci);
2179 }
2180 
2181 // contracts/NFTBridge.sol
2182 
2183 interface INFTBridge {
2184     struct Transfer {
2185         bytes32 tokenAddress;
2186         uint16 tokenChain;
2187         bytes32 symbol;
2188         bytes32 name;
2189         uint256 tokenID;
2190         string uri;
2191         bytes32 to;
2192         uint16 toChain;
2193     }
2194 
2195     struct SPLCache {
2196         bytes32 name;
2197         bytes32 symbol;
2198     }
2199 
2200      struct RegisterChain {
2201         bytes32 module;
2202         uint8 action;
2203         uint16 chainId;
2204 
2205         uint16 emitterChainID;
2206         bytes32 emitterAddress;
2207     }
2208 
2209     struct UpgradeContract {
2210         bytes32 module;
2211         uint8 action;
2212         uint16 chainId;
2213 
2214         bytes32 newContract;
2215     }
2216 
2217     struct RecoverChainId {
2218         bytes32 module;
2219         uint8 action;
2220 
2221         uint256 evmChainId;
2222         uint16 newChainId;
2223     }
2224 
2225     event ContractUpgraded(address indexed oldContract, address indexed newContract);
2226 
2227     function transferNFT(address token, uint256 tokenID, uint16 recipientChain, bytes32 recipient, uint32 nonce) external payable returns (uint64 sequence);
2228 
2229     function completeTransfer(bytes memory encodeVm) external;
2230 
2231     function encodeTransfer(Transfer memory transfer) external pure returns (bytes memory encoded);
2232 
2233     function parseTransfer(bytes memory encoded) external pure returns (Transfer memory transfer);
2234 
2235     function onERC721Received(address operator, address, uint256, bytes calldata) external view returns (bytes4);
2236 
2237     function governanceActionIsConsumed(bytes32 hash) external view returns (bool);
2238 
2239     function isInitialized(address impl) external view returns (bool);
2240 
2241     function isTransferCompleted(bytes32 hash) external view returns (bool);
2242 
2243     function wormhole() external view returns (IWormhole);
2244 
2245     function chainId() external view returns (uint16);
2246 
2247     function evmChainId() external view returns (uint256);
2248 
2249     function isFork() external view returns (bool);
2250 
2251     function governanceChainId() external view returns (uint16);
2252 
2253     function governanceContract() external view returns (bytes32);
2254 
2255     function wrappedAsset(uint16 tokenChainId, bytes32 tokenAddress) external view returns (address);
2256 
2257     function bridgeContracts(uint16 chainId_) external view returns (bytes32);
2258 
2259     function tokenImplementation() external view returns (address);
2260 
2261     function isWrappedAsset(address token) external view returns (bool);
2262 
2263     function splCache(uint256 tokenId) external view returns (SPLCache memory);
2264 
2265     function finality() external view returns (uint8);
2266 
2267     function initialize() external;
2268 
2269     function implementation() external view returns (address);
2270 
2271     function registerChain(bytes memory encodedVM) external;
2272 
2273     function upgrade(bytes memory encodedVM) external;
2274 
2275     function submitRecoverChainId(bytes memory encodedVM) external;
2276 
2277     function parseRegisterChain(bytes memory encoded) external pure returns(RegisterChain memory chain);
2278 
2279     function parseUpgrade(bytes memory encoded) external pure returns(UpgradeContract memory chain);
2280 
2281     function parseRecoverChainId(bytes memory encodedRecoverChainId) external pure returns (RecoverChainId memory rci);
2282 }
2283 
2284 contract CooGenesis is AccessControl, ERC721, ICooGenesis {
2285     enum BridgeType {
2286         UNDEFINED,
2287         TOKEN,
2288         NFT
2289     }
2290 
2291     // === STORAGE ===
2292 
2293     IWormhole immutable wormhole;
2294     ITokenBridge immutable tokenBridge;
2295     INFTBridge immutable nftBridge;
2296 
2297     // === Activity Info ===
2298     uint256 public override startTime;
2299     uint256 public override endTime;
2300 
2301     //criteria
2302     HashCriterion[] private _criteria;
2303 
2304     // === ERC721 Token Info ===
2305     uint256 private _mintedPublic;
2306     uint256 private _mintedReserve;
2307     uint256 private _mintedL2;
2308     uint256 private _resMax;
2309     uint256 private _pubMax;
2310     string private _uri;
2311     uint256 public override maxSupply;
2312     mapping(address => uint256) private _publicMintRecipientToTokenId;
2313     mapping(address => uint256) private _l2MintRecipientToTokenId;
2314 
2315     //keccak256("L2_Authority")
2316     bytes32 public constant L2_ROLLUP_ROLE = 0x87bf82161f347912a342aa475f2fa76a12e8d59a43bda030a18194c8375a4760;
2317 
2318     constructor(
2319         address _wormhole,
2320         address _tokenBridge,
2321         address _nftBridge,
2322         uint256 _maxSupply,
2323         uint256 _reserveMax,
2324         uint256 _publicMax,
2325         uint256 _start,
2326         uint256 _end,
2327         string memory name,
2328         string memory symbol,
2329         string memory _baseUri
2330     ) ERC721(name, symbol) {
2331         require(_reserveMax <= _maxSupply, "reserveMax cannot be greater than max");
2332         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
2333         wormhole = IWormhole(_wormhole);
2334         tokenBridge = ITokenBridge(_tokenBridge);
2335         nftBridge = INFTBridge(_nftBridge);
2336         _uri = _baseUri;
2337         maxSupply = _maxSupply;
2338         _resMax = _reserveMax;
2339         _pubMax = _publicMax;
2340         _setStartAndEndTime(_start, _end);
2341     }
2342 
2343     function _baseURI() internal view override returns (string memory) {
2344         return _uri;
2345     }
2346 
2347     function totalSupply() public view override returns (uint256) {
2348         return _mintedPublic + _mintedReserve + _mintedL2;
2349     }
2350 
2351     function getTokenIdFromAddress(address owner) external view override returns (uint256) {
2352         return _publicMintRecipientToTokenId[owner];
2353     }
2354 
2355     function getL2TokenIdFromAddress(address owner) external view returns (uint256) {
2356         return _l2MintRecipientToTokenId[owner];
2357     }
2358 
2359     function isMintingEligible(bytes memory encodedVm) public view override returns (address to) {
2360         // parse the VAA
2361         (IWormhole.VM memory parsedVm, bool valid, string memory reason) = wormhole.parseAndVerifyVM(encodedVm);
2362         if (!valid) {
2363             revert(reason);
2364         }
2365 
2366         bool currentTimeIsValid = parsedVm.timestamp >= startTime && parsedVm.timestamp < endTime;
2367         if (!currentTimeIsValid) {
2368             revert("current time is invalid");
2369         }
2370 
2371         // verify source emitter and isTransferCompleted
2372         BridgeType bridge = _getBridgeFromEmitter(parsedVm.emitterChainId, parsedVm.emitterAddress);
2373         if (bridge == BridgeType.UNDEFINED) {
2374             revert("bridge undefined");
2375         } else {
2376             bool completed = bridge == BridgeType.TOKEN
2377                 ? tokenBridge.isTransferCompleted(parsedVm.hash)
2378                 : nftBridge.isTransferCompleted(parsedVm.hash);
2379             require(completed, "asset has not completed transfer");
2380         }
2381 
2382         // get the current criterion
2383         HashCriterion memory criterion = _getValidCriterion(parsedVm.timestamp);
2384         bool matched = _isMatching(parsedVm.hash, criterion.luckyNumber, criterion.bitNum);
2385         if (!matched) {
2386             revert("provided hash does not satisfy criterion");
2387         }
2388 
2389         // get recipient
2390         to = _getTransferRecipient(bridge, parsedVm.payload);
2391         require(_publicMintRecipientToTokenId[to] == 0 && to != address(0), "invalid recipient");
2392     }
2393 
2394     function publicMintAvailable() external view returns (bool) {
2395         return _mintedPublic < _pubMax;
2396     }
2397 
2398     function mintInternal(address recipient, uint256 tokenID) external onlyRole(DEFAULT_ADMIN_ROLE) {
2399         require(tokenID <= _resMax && tokenID > 0, "invalid reserve token id");
2400         require(++_mintedReserve <= _resMax, "internal supply exceeds max");
2401         _safeMint(recipient, tokenID);
2402     }
2403 
2404     function mintL2(address recipient, uint256 tokenID) external onlyRole(L2_ROLLUP_ROLE) {
2405         uint256 resMax = _resMax;
2406         uint256 publicMax = _pubMax;
2407         uint256 maxSupplyMem = maxSupply;
2408         require(recipient != address(0), "invalid recipient");
2409         require(tokenID > resMax + publicMax && tokenID <= maxSupplyMem, "invalid l2 token id");
2410         require(++_mintedL2 <= maxSupplyMem - resMax - publicMax, "l2 supply exceeds max");
2411         require(_l2MintRecipientToTokenId[recipient] == 0, "l2 recipient already has token");
2412 
2413         _l2MintRecipientToTokenId[recipient] = tokenID;
2414         _safeMint(recipient, tokenID);
2415     }
2416 
2417     function mint(bytes memory encodedVm) external override {
2418         uint256 mintedPublic = _mintedPublic + 1;
2419         require(mintedPublic <= _pubMax, "public supply exceeds max");
2420         address to = isMintingEligible(encodedVm);
2421         uint256 current = _resMax + mintedPublic;
2422         _publicMintRecipientToTokenId[to] = current;
2423         _mintedPublic = mintedPublic;
2424         _safeMint(to, current);
2425     }
2426 
2427     function supportsInterface(bytes4 interfaceId)
2428         public
2429         view
2430         override(AccessControl, ERC721, IERC165)
2431         returns (bool)
2432     {
2433         return super.supportsInterface(interfaceId);
2434     }
2435 
2436     function addCriterion(uint256 luckyNumber, uint256 numOfBits) external onlyRole(DEFAULT_ADMIN_ROLE) {
2437         _addCriterion(luckyNumber, numOfBits);
2438     }
2439 
2440     function updatePublicMax(uint256 newPublicMax) external onlyRole(DEFAULT_ADMIN_ROLE) {
2441         require(_mintedPublic <= newPublicMax, "cannot reduce max below current minted");
2442         require(_resMax + newPublicMax <= maxSupply, "exceed max supply");
2443         _pubMax = newPublicMax;
2444     }
2445 
2446     // If 2 criteria are added in the same block, the first one will be useless
2447     function _addCriterion(uint256 luckyNumber, uint256 numOfBits) internal {
2448         require(numOfBits > 0, "Patterns cannot be empty");
2449         require(luckyNumber < 2 ** numOfBits, "luckyNumber out of range");
2450 
2451         if (block.timestamp < startTime) {
2452             _criteria[0].intervalBegin = startTime;
2453             _criteria[0].luckyNumber = luckyNumber;
2454             _criteria[0].bitNum = numOfBits;
2455         } else {
2456             HashCriterion memory criterion = HashCriterion({
2457                 intervalBegin: _criteria.length == 0 ? startTime : block.timestamp,
2458                 luckyNumber: luckyNumber,
2459                 bitNum: numOfBits
2460             });
2461             _criteria.push(criterion);
2462         }
2463     }
2464 
2465     function printAllCriteria() external view returns (HashCriterion[] memory) {
2466         return _criteria;
2467     }
2468 
2469     function updateStartAndEndTime(uint256 _start, uint256 _end) external onlyRole(DEFAULT_ADMIN_ROLE) {
2470         if (block.timestamp < startTime) {
2471             _setStartAndEndTime(_start, _end);
2472             //Update the startTime of the first criterion
2473             _criteria[0].intervalBegin = _start;
2474         } else {
2475             //Do not allow startTime to be updated if the current time is after the startTime
2476             _setStartAndEndTime(startTime, _end);
2477         }
2478     }
2479 
2480     function _safeMint(address to, uint256 tokenId) internal override {
2481         require(totalSupply() <= maxSupply, "totalSupply > maxSupply");
2482         super._safeMint(to, tokenId);
2483     }
2484 
2485     function _setStartAndEndTime(uint256 _start, uint256 _end) private {
2486         require(_end > _start, "endTime < startTime");
2487         startTime = _start;
2488         endTime = _end;
2489     }
2490 
2491     function _getValidCriterion(uint256 timestamp) private view returns (HashCriterion memory) {
2492         for (uint256 i = _criteria.length - 1; i >= 0; i--) {
2493             HashCriterion memory criterion = _criteria[i];
2494             if (criterion.intervalBegin <= timestamp) {
2495                 return criterion;
2496             }
2497         }
2498         // This should never happen, otherwise it means something is wrong
2499         revert("no valid criterion");
2500     }
2501 
2502     function _generateMask(uint256 bitNum) private pure returns (bytes32 mask) {
2503         require(bitNum > 0 && bitNum <= 32, "invalid bidNum");
2504         mask = bytes32(uint256(2 ** bitNum) - 1);
2505     }
2506 
2507     function _isMatching(bytes32 hash, uint256 luckyNumber, uint256 numOfBits) private pure returns (bool) {
2508         bytes32 mask = _generateMask(numOfBits);
2509         uint256 res = uint256(hash & mask);
2510         return (res <= luckyNumber);
2511     }
2512 
2513     function _getBridgeFromEmitter(uint16 sourceChain, bytes32 sourceEmitter) private view returns (BridgeType) {
2514         bool isTokenBridge = tokenBridge.bridgeContracts(sourceChain) == sourceEmitter
2515             || address(uint160(uint256(sourceEmitter))) == address(tokenBridge);
2516         if (isTokenBridge) {
2517             return BridgeType.TOKEN;
2518         }
2519 
2520         bool isNFTBridge = nftBridge.bridgeContracts(sourceChain) == sourceEmitter
2521             || address(uint160(uint256(sourceEmitter))) == address(nftBridge);
2522         if (isNFTBridge) {
2523             return BridgeType.NFT;
2524         }
2525 
2526         return BridgeType.UNDEFINED;
2527     }
2528 
2529     function _getTransferRecipient(BridgeType bridge, bytes memory encoded) private pure returns (address to) {
2530         bytes32 padded;
2531         if (bridge == BridgeType.TOKEN) {
2532             // 67 is the start of the `to` field in the TransferWithPayload struct
2533             uint256 toStartIndex = 67;
2534             require(encoded.length >= toStartIndex + 32, "invalid payload");
2535             assembly {
2536                 padded := mload(add(add(encoded, 0x20), toStartIndex))
2537             }
2538         } else if (bridge == BridgeType.NFT) {
2539             uint256 toStartIndex = encoded.length - 34;
2540             assembly {
2541                 // 67 is the start of the `to` field in the TransferWithPayload struct
2542                 padded := mload(add(add(encoded, 0x20), toStartIndex))
2543             }
2544         }
2545         if (padded != bytes32(0)) {
2546             to = address(uint160(uint256(padded)));
2547         }
2548     }
2549 }