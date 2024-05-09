1 // File contracts/IApprovalProxy.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.8.0;
5 
6 interface IApprovalProxy {
7   function setApprovalForAll(address _owner, address _spender, bool _approved) external;
8   function isApprovedForAll(address _owner, address _spender, bool _approved) external view returns(bool);
9 }
10 
11 
12 // File lib/operator-filter-registry/src/IOperatorFilterRegistry.sol
13 
14 pragma solidity ^0.8.13;
15 
16 interface IOperatorFilterRegistry {
17     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
18     function register(address registrant) external;
19     function registerAndSubscribe(address registrant, address subscription) external;
20     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
21     function updateOperator(address registrant, address operator, bool filtered) external;
22     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
23     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
24     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
25     function subscribe(address registrant, address registrantToSubscribe) external;
26     function unsubscribe(address registrant, bool copyExistingEntries) external;
27     function subscriptionOf(address addr) external returns (address registrant);
28     function subscribers(address registrant) external returns (address[] memory);
29     function subscriberAt(address registrant, uint256 index) external returns (address);
30     function copyEntriesOf(address registrant, address registrantToCopy) external;
31     function isOperatorFiltered(address registrant, address operator) external returns (bool);
32     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
33     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
34     function filteredOperators(address addr) external returns (address[] memory);
35     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
36     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
37     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
38     function isRegistered(address addr) external returns (bool);
39     function codeHashOf(address addr) external returns (bytes32);
40 }
41 
42 
43 // File lib/operator-filter-registry/src/OperatorFilterer.sol
44 
45 pragma solidity ^0.8.13;
46 
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry constant operatorFilterRegistry =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(operatorFilterRegistry).code.length > 0) {
58             if (subscribe) {
59                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     operatorFilterRegistry.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Check registry code length to facilitate testing in environments without a deployed registry.
72         if (address(operatorFilterRegistry).code.length > 0) {
73             // Allow spending tokens from addresses with balance
74             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75             // from an EOA.
76             if (from == msg.sender) {
77                 _;
78                 return;
79             }
80             if (
81                 !(
82                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
83                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
84                 )
85             ) {
86                 revert OperatorNotAllowed(msg.sender);
87             }
88         }
89         _;
90     }
91 }
92 
93 
94 // File lib/operator-filter-registry/src/DefaultOperatorFilterer.sol
95 
96 pragma solidity ^0.8.13;
97 
98 abstract contract DefaultOperatorFilterer is OperatorFilterer {
99     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
100 
101     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
102 }
103 
104 
105 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         return msg.data;
128     }
129 }
130 
131 
132 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
133 
134 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Contract module which provides a basic access control mechanism, where
140  * there is an account (an owner) that can be granted exclusive access to
141  * specific functions.
142  *
143  * By default, the owner account will be the one that deploys the contract. This
144  * can later be changed with {transferOwnership}.
145  *
146  * This module is used through inheritance. It will make available the modifier
147  * `onlyOwner`, which can be applied to your functions to restrict their use to
148  * the owner.
149  */
150 abstract contract Ownable is Context {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor() {
159         _transferOwnership(_msgSender());
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         _checkOwner();
167         _;
168     }
169 
170     /**
171      * @dev Returns the address of the current owner.
172      */
173     function owner() public view virtual returns (address) {
174         return _owner;
175     }
176 
177     /**
178      * @dev Throws if the sender is not the owner.
179      */
180     function _checkOwner() internal view virtual {
181         require(owner() == _msgSender(), "Ownable: caller is not the owner");
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Internal function without access restriction.
207      */
208     function _transferOwnership(address newOwner) internal virtual {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 
216 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.8.0
217 
218 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev External interface of AccessControl declared to support ERC165 detection.
224  */
225 interface IAccessControl {
226     /**
227      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
228      *
229      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
230      * {RoleAdminChanged} not being emitted signaling this.
231      *
232      * _Available since v3.1._
233      */
234     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
235 
236     /**
237      * @dev Emitted when `account` is granted `role`.
238      *
239      * `sender` is the account that originated the contract call, an admin role
240      * bearer except when using {AccessControl-_setupRole}.
241      */
242     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
243 
244     /**
245      * @dev Emitted when `account` is revoked `role`.
246      *
247      * `sender` is the account that originated the contract call:
248      *   - if using `revokeRole`, it is the admin role bearer
249      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
250      */
251     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
252 
253     /**
254      * @dev Returns `true` if `account` has been granted `role`.
255      */
256     function hasRole(bytes32 role, address account) external view returns (bool);
257 
258     /**
259      * @dev Returns the admin role that controls `role`. See {grantRole} and
260      * {revokeRole}.
261      *
262      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
263      */
264     function getRoleAdmin(bytes32 role) external view returns (bytes32);
265 
266     /**
267      * @dev Grants `role` to `account`.
268      *
269      * If `account` had not been already granted `role`, emits a {RoleGranted}
270      * event.
271      *
272      * Requirements:
273      *
274      * - the caller must have ``role``'s admin role.
275      */
276     function grantRole(bytes32 role, address account) external;
277 
278     /**
279      * @dev Revokes `role` from `account`.
280      *
281      * If `account` had been granted `role`, emits a {RoleRevoked} event.
282      *
283      * Requirements:
284      *
285      * - the caller must have ``role``'s admin role.
286      */
287     function revokeRole(bytes32 role, address account) external;
288 
289     /**
290      * @dev Revokes `role` from the calling account.
291      *
292      * Roles are often managed via {grantRole} and {revokeRole}: this function's
293      * purpose is to provide a mechanism for accounts to lose their privileges
294      * if they are compromised (such as when a trusted device is misplaced).
295      *
296      * If the calling account had been granted `role`, emits a {RoleRevoked}
297      * event.
298      *
299      * Requirements:
300      *
301      * - the caller must be `account`.
302      */
303     function renounceRole(bytes32 role, address account) external;
304 }
305 
306 
307 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
308 
309 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Standard math utilities missing in the Solidity language.
315  */
316 library Math {
317     enum Rounding {
318         Down, // Toward negative infinity
319         Up, // Toward infinity
320         Zero // Toward zero
321     }
322 
323     /**
324      * @dev Returns the largest of two numbers.
325      */
326     function max(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a > b ? a : b;
328     }
329 
330     /**
331      * @dev Returns the smallest of two numbers.
332      */
333     function min(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a < b ? a : b;
335     }
336 
337     /**
338      * @dev Returns the average of two numbers. The result is rounded towards
339      * zero.
340      */
341     function average(uint256 a, uint256 b) internal pure returns (uint256) {
342         // (a + b) / 2 can overflow.
343         return (a & b) + (a ^ b) / 2;
344     }
345 
346     /**
347      * @dev Returns the ceiling of the division of two numbers.
348      *
349      * This differs from standard division with `/` in that it rounds up instead
350      * of rounding down.
351      */
352     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
353         // (a + b - 1) / b can overflow on addition, so we distribute.
354         return a == 0 ? 0 : (a - 1) / b + 1;
355     }
356 
357     /**
358      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
359      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
360      * with further edits by Uniswap Labs also under MIT license.
361      */
362     function mulDiv(
363         uint256 x,
364         uint256 y,
365         uint256 denominator
366     ) internal pure returns (uint256 result) {
367         unchecked {
368             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
369             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
370             // variables such that product = prod1 * 2^256 + prod0.
371             uint256 prod0; // Least significant 256 bits of the product
372             uint256 prod1; // Most significant 256 bits of the product
373             assembly {
374                 let mm := mulmod(x, y, not(0))
375                 prod0 := mul(x, y)
376                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
377             }
378 
379             // Handle non-overflow cases, 256 by 256 division.
380             if (prod1 == 0) {
381                 return prod0 / denominator;
382             }
383 
384             // Make sure the result is less than 2^256. Also prevents denominator == 0.
385             require(denominator > prod1);
386 
387             ///////////////////////////////////////////////
388             // 512 by 256 division.
389             ///////////////////////////////////////////////
390 
391             // Make division exact by subtracting the remainder from [prod1 prod0].
392             uint256 remainder;
393             assembly {
394                 // Compute remainder using mulmod.
395                 remainder := mulmod(x, y, denominator)
396 
397                 // Subtract 256 bit number from 512 bit number.
398                 prod1 := sub(prod1, gt(remainder, prod0))
399                 prod0 := sub(prod0, remainder)
400             }
401 
402             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
403             // See https://cs.stackexchange.com/q/138556/92363.
404 
405             // Does not overflow because the denominator cannot be zero at this stage in the function.
406             uint256 twos = denominator & (~denominator + 1);
407             assembly {
408                 // Divide denominator by twos.
409                 denominator := div(denominator, twos)
410 
411                 // Divide [prod1 prod0] by twos.
412                 prod0 := div(prod0, twos)
413 
414                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
415                 twos := add(div(sub(0, twos), twos), 1)
416             }
417 
418             // Shift in bits from prod1 into prod0.
419             prod0 |= prod1 * twos;
420 
421             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
422             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
423             // four bits. That is, denominator * inv = 1 mod 2^4.
424             uint256 inverse = (3 * denominator) ^ 2;
425 
426             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
427             // in modular arithmetic, doubling the correct bits in each step.
428             inverse *= 2 - denominator * inverse; // inverse mod 2^8
429             inverse *= 2 - denominator * inverse; // inverse mod 2^16
430             inverse *= 2 - denominator * inverse; // inverse mod 2^32
431             inverse *= 2 - denominator * inverse; // inverse mod 2^64
432             inverse *= 2 - denominator * inverse; // inverse mod 2^128
433             inverse *= 2 - denominator * inverse; // inverse mod 2^256
434 
435             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
436             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
437             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
438             // is no longer required.
439             result = prod0 * inverse;
440             return result;
441         }
442     }
443 
444     /**
445      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
446      */
447     function mulDiv(
448         uint256 x,
449         uint256 y,
450         uint256 denominator,
451         Rounding rounding
452     ) internal pure returns (uint256) {
453         uint256 result = mulDiv(x, y, denominator);
454         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
455             result += 1;
456         }
457         return result;
458     }
459 
460     /**
461      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
462      *
463      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
464      */
465     function sqrt(uint256 a) internal pure returns (uint256) {
466         if (a == 0) {
467             return 0;
468         }
469 
470         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
471         //
472         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
473         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
474         //
475         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
476         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
477         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
478         //
479         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
480         uint256 result = 1 << (log2(a) >> 1);
481 
482         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
483         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
484         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
485         // into the expected uint128 result.
486         unchecked {
487             result = (result + a / result) >> 1;
488             result = (result + a / result) >> 1;
489             result = (result + a / result) >> 1;
490             result = (result + a / result) >> 1;
491             result = (result + a / result) >> 1;
492             result = (result + a / result) >> 1;
493             result = (result + a / result) >> 1;
494             return min(result, a / result);
495         }
496     }
497 
498     /**
499      * @notice Calculates sqrt(a), following the selected rounding direction.
500      */
501     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
502         unchecked {
503             uint256 result = sqrt(a);
504             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
505         }
506     }
507 
508     /**
509      * @dev Return the log in base 2, rounded down, of a positive value.
510      * Returns 0 if given 0.
511      */
512     function log2(uint256 value) internal pure returns (uint256) {
513         uint256 result = 0;
514         unchecked {
515             if (value >> 128 > 0) {
516                 value >>= 128;
517                 result += 128;
518             }
519             if (value >> 64 > 0) {
520                 value >>= 64;
521                 result += 64;
522             }
523             if (value >> 32 > 0) {
524                 value >>= 32;
525                 result += 32;
526             }
527             if (value >> 16 > 0) {
528                 value >>= 16;
529                 result += 16;
530             }
531             if (value >> 8 > 0) {
532                 value >>= 8;
533                 result += 8;
534             }
535             if (value >> 4 > 0) {
536                 value >>= 4;
537                 result += 4;
538             }
539             if (value >> 2 > 0) {
540                 value >>= 2;
541                 result += 2;
542             }
543             if (value >> 1 > 0) {
544                 result += 1;
545             }
546         }
547         return result;
548     }
549 
550     /**
551      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
552      * Returns 0 if given 0.
553      */
554     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
555         unchecked {
556             uint256 result = log2(value);
557             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
558         }
559     }
560 
561     /**
562      * @dev Return the log in base 10, rounded down, of a positive value.
563      * Returns 0 if given 0.
564      */
565     function log10(uint256 value) internal pure returns (uint256) {
566         uint256 result = 0;
567         unchecked {
568             if (value >= 10**64) {
569                 value /= 10**64;
570                 result += 64;
571             }
572             if (value >= 10**32) {
573                 value /= 10**32;
574                 result += 32;
575             }
576             if (value >= 10**16) {
577                 value /= 10**16;
578                 result += 16;
579             }
580             if (value >= 10**8) {
581                 value /= 10**8;
582                 result += 8;
583             }
584             if (value >= 10**4) {
585                 value /= 10**4;
586                 result += 4;
587             }
588             if (value >= 10**2) {
589                 value /= 10**2;
590                 result += 2;
591             }
592             if (value >= 10**1) {
593                 result += 1;
594             }
595         }
596         return result;
597     }
598 
599     /**
600      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
601      * Returns 0 if given 0.
602      */
603     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
604         unchecked {
605             uint256 result = log10(value);
606             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
607         }
608     }
609 
610     /**
611      * @dev Return the log in base 256, rounded down, of a positive value.
612      * Returns 0 if given 0.
613      *
614      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
615      */
616     function log256(uint256 value) internal pure returns (uint256) {
617         uint256 result = 0;
618         unchecked {
619             if (value >> 128 > 0) {
620                 value >>= 128;
621                 result += 16;
622             }
623             if (value >> 64 > 0) {
624                 value >>= 64;
625                 result += 8;
626             }
627             if (value >> 32 > 0) {
628                 value >>= 32;
629                 result += 4;
630             }
631             if (value >> 16 > 0) {
632                 value >>= 16;
633                 result += 2;
634             }
635             if (value >> 8 > 0) {
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
646     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
647         unchecked {
648             uint256 result = log256(value);
649             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
650         }
651     }
652 }
653 
654 
655 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
656 
657 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @dev String operations.
663  */
664 library Strings {
665     bytes16 private constant _SYMBOLS = "0123456789abcdef";
666     uint8 private constant _ADDRESS_LENGTH = 20;
667 
668     /**
669      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
670      */
671     function toString(uint256 value) internal pure returns (string memory) {
672         unchecked {
673             uint256 length = Math.log10(value) + 1;
674             string memory buffer = new string(length);
675             uint256 ptr;
676             /// @solidity memory-safe-assembly
677             assembly {
678                 ptr := add(buffer, add(32, length))
679             }
680             while (true) {
681                 ptr--;
682                 /// @solidity memory-safe-assembly
683                 assembly {
684                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
685                 }
686                 value /= 10;
687                 if (value == 0) break;
688             }
689             return buffer;
690         }
691     }
692 
693     /**
694      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
695      */
696     function toHexString(uint256 value) internal pure returns (string memory) {
697         unchecked {
698             return toHexString(value, Math.log256(value) + 1);
699         }
700     }
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
704      */
705     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
706         bytes memory buffer = new bytes(2 * length + 2);
707         buffer[0] = "0";
708         buffer[1] = "x";
709         for (uint256 i = 2 * length + 1; i > 1; --i) {
710             buffer[i] = _SYMBOLS[value & 0xf];
711             value >>= 4;
712         }
713         require(value == 0, "Strings: hex length insufficient");
714         return string(buffer);
715     }
716 
717     /**
718      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
719      */
720     function toHexString(address addr) internal pure returns (string memory) {
721         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
722     }
723 }
724 
725 
726 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
727 
728 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 /**
733  * @dev Interface of the ERC165 standard, as defined in the
734  * https://eips.ethereum.org/EIPS/eip-165[EIP].
735  *
736  * Implementers can declare support of contract interfaces, which can then be
737  * queried by others ({ERC165Checker}).
738  *
739  * For an implementation, see {ERC165}.
740  */
741 interface IERC165 {
742     /**
743      * @dev Returns true if this contract implements the interface defined by
744      * `interfaceId`. See the corresponding
745      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
746      * to learn more about how these ids are created.
747      *
748      * This function call must use less than 30 000 gas.
749      */
750     function supportsInterface(bytes4 interfaceId) external view returns (bool);
751 }
752 
753 
754 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
755 
756 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 /**
761  * @dev Implementation of the {IERC165} interface.
762  *
763  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
764  * for the additional interface id that will be supported. For example:
765  *
766  * ```solidity
767  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
768  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
769  * }
770  * ```
771  *
772  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
773  */
774 abstract contract ERC165 is IERC165 {
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
779         return interfaceId == type(IERC165).interfaceId;
780     }
781 }
782 
783 
784 // File @openzeppelin/contracts/access/AccessControl.sol@v4.8.0
785 
786 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 
792 
793 /**
794  * @dev Contract module that allows children to implement role-based access
795  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
796  * members except through off-chain means by accessing the contract event logs. Some
797  * applications may benefit from on-chain enumerability, for those cases see
798  * {AccessControlEnumerable}.
799  *
800  * Roles are referred to by their `bytes32` identifier. These should be exposed
801  * in the external API and be unique. The best way to achieve this is by
802  * using `public constant` hash digests:
803  *
804  * ```
805  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
806  * ```
807  *
808  * Roles can be used to represent a set of permissions. To restrict access to a
809  * function call, use {hasRole}:
810  *
811  * ```
812  * function foo() public {
813  *     require(hasRole(MY_ROLE, msg.sender));
814  *     ...
815  * }
816  * ```
817  *
818  * Roles can be granted and revoked dynamically via the {grantRole} and
819  * {revokeRole} functions. Each role has an associated admin role, and only
820  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
821  *
822  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
823  * that only accounts with this role will be able to grant or revoke other
824  * roles. More complex role relationships can be created by using
825  * {_setRoleAdmin}.
826  *
827  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
828  * grant and revoke this role. Extra precautions should be taken to secure
829  * accounts that have been granted it.
830  */
831 abstract contract AccessControl is Context, IAccessControl, ERC165 {
832     struct RoleData {
833         mapping(address => bool) members;
834         bytes32 adminRole;
835     }
836 
837     mapping(bytes32 => RoleData) private _roles;
838 
839     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
840 
841     /**
842      * @dev Modifier that checks that an account has a specific role. Reverts
843      * with a standardized message including the required role.
844      *
845      * The format of the revert reason is given by the following regular expression:
846      *
847      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
848      *
849      * _Available since v4.1._
850      */
851     modifier onlyRole(bytes32 role) {
852         _checkRole(role);
853         _;
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
860         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev Returns `true` if `account` has been granted `role`.
865      */
866     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
867         return _roles[role].members[account];
868     }
869 
870     /**
871      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
872      * Overriding this function changes the behavior of the {onlyRole} modifier.
873      *
874      * Format of the revert message is described in {_checkRole}.
875      *
876      * _Available since v4.6._
877      */
878     function _checkRole(bytes32 role) internal view virtual {
879         _checkRole(role, _msgSender());
880     }
881 
882     /**
883      * @dev Revert with a standard message if `account` is missing `role`.
884      *
885      * The format of the revert reason is given by the following regular expression:
886      *
887      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
888      */
889     function _checkRole(bytes32 role, address account) internal view virtual {
890         if (!hasRole(role, account)) {
891             revert(
892                 string(
893                     abi.encodePacked(
894                         "AccessControl: account ",
895                         Strings.toHexString(account),
896                         " is missing role ",
897                         Strings.toHexString(uint256(role), 32)
898                     )
899                 )
900             );
901         }
902     }
903 
904     /**
905      * @dev Returns the admin role that controls `role`. See {grantRole} and
906      * {revokeRole}.
907      *
908      * To change a role's admin, use {_setRoleAdmin}.
909      */
910     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
911         return _roles[role].adminRole;
912     }
913 
914     /**
915      * @dev Grants `role` to `account`.
916      *
917      * If `account` had not been already granted `role`, emits a {RoleGranted}
918      * event.
919      *
920      * Requirements:
921      *
922      * - the caller must have ``role``'s admin role.
923      *
924      * May emit a {RoleGranted} event.
925      */
926     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
927         _grantRole(role, account);
928     }
929 
930     /**
931      * @dev Revokes `role` from `account`.
932      *
933      * If `account` had been granted `role`, emits a {RoleRevoked} event.
934      *
935      * Requirements:
936      *
937      * - the caller must have ``role``'s admin role.
938      *
939      * May emit a {RoleRevoked} event.
940      */
941     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
942         _revokeRole(role, account);
943     }
944 
945     /**
946      * @dev Revokes `role` from the calling account.
947      *
948      * Roles are often managed via {grantRole} and {revokeRole}: this function's
949      * purpose is to provide a mechanism for accounts to lose their privileges
950      * if they are compromised (such as when a trusted device is misplaced).
951      *
952      * If the calling account had been revoked `role`, emits a {RoleRevoked}
953      * event.
954      *
955      * Requirements:
956      *
957      * - the caller must be `account`.
958      *
959      * May emit a {RoleRevoked} event.
960      */
961     function renounceRole(bytes32 role, address account) public virtual override {
962         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
963 
964         _revokeRole(role, account);
965     }
966 
967     /**
968      * @dev Grants `role` to `account`.
969      *
970      * If `account` had not been already granted `role`, emits a {RoleGranted}
971      * event. Note that unlike {grantRole}, this function doesn't perform any
972      * checks on the calling account.
973      *
974      * May emit a {RoleGranted} event.
975      *
976      * [WARNING]
977      * ====
978      * This function should only be called from the constructor when setting
979      * up the initial roles for the system.
980      *
981      * Using this function in any other way is effectively circumventing the admin
982      * system imposed by {AccessControl}.
983      * ====
984      *
985      * NOTE: This function is deprecated in favor of {_grantRole}.
986      */
987     function _setupRole(bytes32 role, address account) internal virtual {
988         _grantRole(role, account);
989     }
990 
991     /**
992      * @dev Sets `adminRole` as ``role``'s admin role.
993      *
994      * Emits a {RoleAdminChanged} event.
995      */
996     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
997         bytes32 previousAdminRole = getRoleAdmin(role);
998         _roles[role].adminRole = adminRole;
999         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1000     }
1001 
1002     /**
1003      * @dev Grants `role` to `account`.
1004      *
1005      * Internal function without access restriction.
1006      *
1007      * May emit a {RoleGranted} event.
1008      */
1009     function _grantRole(bytes32 role, address account) internal virtual {
1010         if (!hasRole(role, account)) {
1011             _roles[role].members[account] = true;
1012             emit RoleGranted(role, account, _msgSender());
1013         }
1014     }
1015 
1016     /**
1017      * @dev Revokes `role` from `account`.
1018      *
1019      * Internal function without access restriction.
1020      *
1021      * May emit a {RoleRevoked} event.
1022      */
1023     function _revokeRole(bytes32 role, address account) internal virtual {
1024         if (hasRole(role, account)) {
1025             _roles[role].members[account] = false;
1026             emit RoleRevoked(role, account, _msgSender());
1027         }
1028     }
1029 }
1030 
1031 
1032 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.0
1033 
1034 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 /**
1039  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1040  *
1041  * These functions can be used to verify that a message was signed by the holder
1042  * of the private keys of a given address.
1043  */
1044 library ECDSA {
1045     enum RecoverError {
1046         NoError,
1047         InvalidSignature,
1048         InvalidSignatureLength,
1049         InvalidSignatureS,
1050         InvalidSignatureV // Deprecated in v4.8
1051     }
1052 
1053     function _throwError(RecoverError error) private pure {
1054         if (error == RecoverError.NoError) {
1055             return; // no error: do nothing
1056         } else if (error == RecoverError.InvalidSignature) {
1057             revert("ECDSA: invalid signature");
1058         } else if (error == RecoverError.InvalidSignatureLength) {
1059             revert("ECDSA: invalid signature length");
1060         } else if (error == RecoverError.InvalidSignatureS) {
1061             revert("ECDSA: invalid signature 's' value");
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns the address that signed a hashed message (`hash`) with
1067      * `signature` or error string. This address can then be used for verification purposes.
1068      *
1069      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1070      * this function rejects them by requiring the `s` value to be in the lower
1071      * half order, and the `v` value to be either 27 or 28.
1072      *
1073      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1074      * verification to be secure: it is possible to craft signatures that
1075      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1076      * this is by receiving a hash of the original message (which may otherwise
1077      * be too long), and then calling {toEthSignedMessageHash} on it.
1078      *
1079      * Documentation for signature generation:
1080      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1081      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1082      *
1083      * _Available since v4.3._
1084      */
1085     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1086         if (signature.length == 65) {
1087             bytes32 r;
1088             bytes32 s;
1089             uint8 v;
1090             // ecrecover takes the signature parameters, and the only way to get them
1091             // currently is to use assembly.
1092             /// @solidity memory-safe-assembly
1093             assembly {
1094                 r := mload(add(signature, 0x20))
1095                 s := mload(add(signature, 0x40))
1096                 v := byte(0, mload(add(signature, 0x60)))
1097             }
1098             return tryRecover(hash, v, r, s);
1099         } else {
1100             return (address(0), RecoverError.InvalidSignatureLength);
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns the address that signed a hashed message (`hash`) with
1106      * `signature`. This address can then be used for verification purposes.
1107      *
1108      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1109      * this function rejects them by requiring the `s` value to be in the lower
1110      * half order, and the `v` value to be either 27 or 28.
1111      *
1112      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1113      * verification to be secure: it is possible to craft signatures that
1114      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1115      * this is by receiving a hash of the original message (which may otherwise
1116      * be too long), and then calling {toEthSignedMessageHash} on it.
1117      */
1118     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1119         (address recovered, RecoverError error) = tryRecover(hash, signature);
1120         _throwError(error);
1121         return recovered;
1122     }
1123 
1124     /**
1125      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1126      *
1127      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1128      *
1129      * _Available since v4.3._
1130      */
1131     function tryRecover(
1132         bytes32 hash,
1133         bytes32 r,
1134         bytes32 vs
1135     ) internal pure returns (address, RecoverError) {
1136         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1137         uint8 v = uint8((uint256(vs) >> 255) + 27);
1138         return tryRecover(hash, v, r, s);
1139     }
1140 
1141     /**
1142      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1143      *
1144      * _Available since v4.2._
1145      */
1146     function recover(
1147         bytes32 hash,
1148         bytes32 r,
1149         bytes32 vs
1150     ) internal pure returns (address) {
1151         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1152         _throwError(error);
1153         return recovered;
1154     }
1155 
1156     /**
1157      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1158      * `r` and `s` signature fields separately.
1159      *
1160      * _Available since v4.3._
1161      */
1162     function tryRecover(
1163         bytes32 hash,
1164         uint8 v,
1165         bytes32 r,
1166         bytes32 s
1167     ) internal pure returns (address, RecoverError) {
1168         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1169         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1170         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1171         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1172         //
1173         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1174         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1175         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1176         // these malleable signatures as well.
1177         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1178             return (address(0), RecoverError.InvalidSignatureS);
1179         }
1180 
1181         // If the signature is valid (and not malleable), return the signer address
1182         address signer = ecrecover(hash, v, r, s);
1183         if (signer == address(0)) {
1184             return (address(0), RecoverError.InvalidSignature);
1185         }
1186 
1187         return (signer, RecoverError.NoError);
1188     }
1189 
1190     /**
1191      * @dev Overload of {ECDSA-recover} that receives the `v`,
1192      * `r` and `s` signature fields separately.
1193      */
1194     function recover(
1195         bytes32 hash,
1196         uint8 v,
1197         bytes32 r,
1198         bytes32 s
1199     ) internal pure returns (address) {
1200         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1201         _throwError(error);
1202         return recovered;
1203     }
1204 
1205     /**
1206      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1207      * produces hash corresponding to the one signed with the
1208      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1209      * JSON-RPC method as part of EIP-191.
1210      *
1211      * See {recover}.
1212      */
1213     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1214         // 32 is the length in bytes of hash,
1215         // enforced by the type signature above
1216         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1217     }
1218 
1219     /**
1220      * @dev Returns an Ethereum Signed Message, created from `s`. This
1221      * produces hash corresponding to the one signed with the
1222      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1223      * JSON-RPC method as part of EIP-191.
1224      *
1225      * See {recover}.
1226      */
1227     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1228         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1229     }
1230 
1231     /**
1232      * @dev Returns an Ethereum Signed Typed Data, created from a
1233      * `domainSeparator` and a `structHash`. This produces hash corresponding
1234      * to the one signed with the
1235      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1236      * JSON-RPC method as part of EIP-712.
1237      *
1238      * See {recover}.
1239      */
1240     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1241         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1242     }
1243 }
1244 
1245 
1246 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
1247 
1248 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 /**
1253  * @dev Required interface of an ERC721 compliant contract.
1254  */
1255 interface IERC721 is IERC165 {
1256     /**
1257      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1258      */
1259     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1260 
1261     /**
1262      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1263      */
1264     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1265 
1266     /**
1267      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1268      */
1269     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1270 
1271     /**
1272      * @dev Returns the number of tokens in ``owner``'s account.
1273      */
1274     function balanceOf(address owner) external view returns (uint256 balance);
1275 
1276     /**
1277      * @dev Returns the owner of the `tokenId` token.
1278      *
1279      * Requirements:
1280      *
1281      * - `tokenId` must exist.
1282      */
1283     function ownerOf(uint256 tokenId) external view returns (address owner);
1284 
1285     /**
1286      * @dev Safely transfers `tokenId` token from `from` to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `from` cannot be the zero address.
1291      * - `to` cannot be the zero address.
1292      * - `tokenId` token must exist and be owned by `from`.
1293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function safeTransferFrom(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes calldata data
1303     ) external;
1304 
1305     /**
1306      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1307      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1308      *
1309      * Requirements:
1310      *
1311      * - `from` cannot be the zero address.
1312      * - `to` cannot be the zero address.
1313      * - `tokenId` token must exist and be owned by `from`.
1314      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1315      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function safeTransferFrom(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) external;
1324 
1325     /**
1326      * @dev Transfers `tokenId` token from `from` to `to`.
1327      *
1328      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1329      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1330      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1331      *
1332      * Requirements:
1333      *
1334      * - `from` cannot be the zero address.
1335      * - `to` cannot be the zero address.
1336      * - `tokenId` token must be owned by `from`.
1337      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1338      *
1339      * Emits a {Transfer} event.
1340      */
1341     function transferFrom(
1342         address from,
1343         address to,
1344         uint256 tokenId
1345     ) external;
1346 
1347     /**
1348      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1349      * The approval is cleared when the token is transferred.
1350      *
1351      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1352      *
1353      * Requirements:
1354      *
1355      * - The caller must own the token or be an approved operator.
1356      * - `tokenId` must exist.
1357      *
1358      * Emits an {Approval} event.
1359      */
1360     function approve(address to, uint256 tokenId) external;
1361 
1362     /**
1363      * @dev Approve or remove `operator` as an operator for the caller.
1364      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1365      *
1366      * Requirements:
1367      *
1368      * - The `operator` cannot be the caller.
1369      *
1370      * Emits an {ApprovalForAll} event.
1371      */
1372     function setApprovalForAll(address operator, bool _approved) external;
1373 
1374     /**
1375      * @dev Returns the account approved for `tokenId` token.
1376      *
1377      * Requirements:
1378      *
1379      * - `tokenId` must exist.
1380      */
1381     function getApproved(uint256 tokenId) external view returns (address operator);
1382 
1383     /**
1384      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1385      *
1386      * See {setApprovalForAll}
1387      */
1388     function isApprovedForAll(address owner, address operator) external view returns (bool);
1389 }
1390 
1391 
1392 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.0
1393 
1394 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1395 
1396 pragma solidity ^0.8.0;
1397 
1398 /**
1399  * @title ERC721 token receiver interface
1400  * @dev Interface for any contract that wants to support safeTransfers
1401  * from ERC721 asset contracts.
1402  */
1403 interface IERC721Receiver {
1404     /**
1405      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1406      * by `operator` from `from`, this function is called.
1407      *
1408      * It must return its Solidity selector to confirm the token transfer.
1409      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1410      *
1411      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1412      */
1413     function onERC721Received(
1414         address operator,
1415         address from,
1416         uint256 tokenId,
1417         bytes calldata data
1418     ) external returns (bytes4);
1419 }
1420 
1421 
1422 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
1423 
1424 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1425 
1426 pragma solidity ^0.8.1;
1427 
1428 /**
1429  * @dev Collection of functions related to the address type
1430  */
1431 library Address {
1432     /**
1433      * @dev Returns true if `account` is a contract.
1434      *
1435      * [IMPORTANT]
1436      * ====
1437      * It is unsafe to assume that an address for which this function returns
1438      * false is an externally-owned account (EOA) and not a contract.
1439      *
1440      * Among others, `isContract` will return false for the following
1441      * types of addresses:
1442      *
1443      *  - an externally-owned account
1444      *  - a contract in construction
1445      *  - an address where a contract will be created
1446      *  - an address where a contract lived, but was destroyed
1447      * ====
1448      *
1449      * [IMPORTANT]
1450      * ====
1451      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1452      *
1453      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1454      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1455      * constructor.
1456      * ====
1457      */
1458     function isContract(address account) internal view returns (bool) {
1459         // This method relies on extcodesize/address.code.length, which returns 0
1460         // for contracts in construction, since the code is only stored at the end
1461         // of the constructor execution.
1462 
1463         return account.code.length > 0;
1464     }
1465 
1466     /**
1467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1468      * `recipient`, forwarding all available gas and reverting on errors.
1469      *
1470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1472      * imposed by `transfer`, making them unable to receive funds via
1473      * `transfer`. {sendValue} removes this limitation.
1474      *
1475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1476      *
1477      * IMPORTANT: because control is transferred to `recipient`, care must be
1478      * taken to not create reentrancy vulnerabilities. Consider using
1479      * {ReentrancyGuard} or the
1480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1481      */
1482     function sendValue(address payable recipient, uint256 amount) internal {
1483         require(address(this).balance >= amount, "Address: insufficient balance");
1484 
1485         (bool success, ) = recipient.call{value: amount}("");
1486         require(success, "Address: unable to send value, recipient may have reverted");
1487     }
1488 
1489     /**
1490      * @dev Performs a Solidity function call using a low level `call`. A
1491      * plain `call` is an unsafe replacement for a function call: use this
1492      * function instead.
1493      *
1494      * If `target` reverts with a revert reason, it is bubbled up by this
1495      * function (like regular Solidity function calls).
1496      *
1497      * Returns the raw returned data. To convert to the expected return value,
1498      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1499      *
1500      * Requirements:
1501      *
1502      * - `target` must be a contract.
1503      * - calling `target` with `data` must not revert.
1504      *
1505      * _Available since v3.1._
1506      */
1507     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1508         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1509     }
1510 
1511     /**
1512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1513      * `errorMessage` as a fallback revert reason when `target` reverts.
1514      *
1515      * _Available since v3.1._
1516      */
1517     function functionCall(
1518         address target,
1519         bytes memory data,
1520         string memory errorMessage
1521     ) internal returns (bytes memory) {
1522         return functionCallWithValue(target, data, 0, errorMessage);
1523     }
1524 
1525     /**
1526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1527      * but also transferring `value` wei to `target`.
1528      *
1529      * Requirements:
1530      *
1531      * - the calling contract must have an ETH balance of at least `value`.
1532      * - the called Solidity function must be `payable`.
1533      *
1534      * _Available since v3.1._
1535      */
1536     function functionCallWithValue(
1537         address target,
1538         bytes memory data,
1539         uint256 value
1540     ) internal returns (bytes memory) {
1541         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1542     }
1543 
1544     /**
1545      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1546      * with `errorMessage` as a fallback revert reason when `target` reverts.
1547      *
1548      * _Available since v3.1._
1549      */
1550     function functionCallWithValue(
1551         address target,
1552         bytes memory data,
1553         uint256 value,
1554         string memory errorMessage
1555     ) internal returns (bytes memory) {
1556         require(address(this).balance >= value, "Address: insufficient balance for call");
1557         (bool success, bytes memory returndata) = target.call{value: value}(data);
1558         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1559     }
1560 
1561     /**
1562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1563      * but performing a static call.
1564      *
1565      * _Available since v3.3._
1566      */
1567     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1568         return functionStaticCall(target, data, "Address: low-level static call failed");
1569     }
1570 
1571     /**
1572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1573      * but performing a static call.
1574      *
1575      * _Available since v3.3._
1576      */
1577     function functionStaticCall(
1578         address target,
1579         bytes memory data,
1580         string memory errorMessage
1581     ) internal view returns (bytes memory) {
1582         (bool success, bytes memory returndata) = target.staticcall(data);
1583         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1584     }
1585 
1586     /**
1587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1588      * but performing a delegate call.
1589      *
1590      * _Available since v3.4._
1591      */
1592     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1593         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1594     }
1595 
1596     /**
1597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1598      * but performing a delegate call.
1599      *
1600      * _Available since v3.4._
1601      */
1602     function functionDelegateCall(
1603         address target,
1604         bytes memory data,
1605         string memory errorMessage
1606     ) internal returns (bytes memory) {
1607         (bool success, bytes memory returndata) = target.delegatecall(data);
1608         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1609     }
1610 
1611     /**
1612      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1613      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1614      *
1615      * _Available since v4.8._
1616      */
1617     function verifyCallResultFromTarget(
1618         address target,
1619         bool success,
1620         bytes memory returndata,
1621         string memory errorMessage
1622     ) internal view returns (bytes memory) {
1623         if (success) {
1624             if (returndata.length == 0) {
1625                 // only check isContract if the call was successful and the return data is empty
1626                 // otherwise we already know that it was a contract
1627                 require(isContract(target), "Address: call to non-contract");
1628             }
1629             return returndata;
1630         } else {
1631             _revert(returndata, errorMessage);
1632         }
1633     }
1634 
1635     /**
1636      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1637      * revert reason or using the provided one.
1638      *
1639      * _Available since v4.3._
1640      */
1641     function verifyCallResult(
1642         bool success,
1643         bytes memory returndata,
1644         string memory errorMessage
1645     ) internal pure returns (bytes memory) {
1646         if (success) {
1647             return returndata;
1648         } else {
1649             _revert(returndata, errorMessage);
1650         }
1651     }
1652 
1653     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1654         // Look for revert reason and bubble it up if present
1655         if (returndata.length > 0) {
1656             // The easiest way to bubble the revert reason is using memory via assembly
1657             /// @solidity memory-safe-assembly
1658             assembly {
1659                 let returndata_size := mload(returndata)
1660                 revert(add(32, returndata), returndata_size)
1661             }
1662         } else {
1663             revert(errorMessage);
1664         }
1665     }
1666 }
1667 
1668 
1669 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.0
1670 
1671 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1672 
1673 pragma solidity ^0.8.0;
1674 
1675 /**
1676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1677  * @dev See https://eips.ethereum.org/EIPS/eip-721
1678  */
1679 interface IERC721Metadata is IERC721 {
1680     /**
1681      * @dev Returns the token collection name.
1682      */
1683     function name() external view returns (string memory);
1684 
1685     /**
1686      * @dev Returns the token collection symbol.
1687      */
1688     function symbol() external view returns (string memory);
1689 
1690     /**
1691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1692      */
1693     function tokenURI(uint256 tokenId) external view returns (string memory);
1694 }
1695 
1696 
1697 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.0
1698 
1699 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1700 
1701 pragma solidity ^0.8.0;
1702 
1703 
1704 
1705 
1706 
1707 
1708 
1709 /**
1710  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1711  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1712  * {ERC721Enumerable}.
1713  */
1714 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1715     using Address for address;
1716     using Strings for uint256;
1717 
1718     // Token name
1719     string private _name;
1720 
1721     // Token symbol
1722     string private _symbol;
1723 
1724     // Mapping from token ID to owner address
1725     mapping(uint256 => address) private _owners;
1726 
1727     // Mapping owner address to token count
1728     mapping(address => uint256) private _balances;
1729 
1730     // Mapping from token ID to approved address
1731     mapping(uint256 => address) private _tokenApprovals;
1732 
1733     // Mapping from owner to operator approvals
1734     mapping(address => mapping(address => bool)) private _operatorApprovals;
1735 
1736     /**
1737      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1738      */
1739     constructor(string memory name_, string memory symbol_) {
1740         _name = name_;
1741         _symbol = symbol_;
1742     }
1743 
1744     /**
1745      * @dev See {IERC165-supportsInterface}.
1746      */
1747     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1748         return
1749             interfaceId == type(IERC721).interfaceId ||
1750             interfaceId == type(IERC721Metadata).interfaceId ||
1751             super.supportsInterface(interfaceId);
1752     }
1753 
1754     /**
1755      * @dev See {IERC721-balanceOf}.
1756      */
1757     function balanceOf(address owner) public view virtual override returns (uint256) {
1758         require(owner != address(0), "ERC721: address zero is not a valid owner");
1759         return _balances[owner];
1760     }
1761 
1762     /**
1763      * @dev See {IERC721-ownerOf}.
1764      */
1765     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1766         address owner = _ownerOf(tokenId);
1767         require(owner != address(0), "ERC721: invalid token ID");
1768         return owner;
1769     }
1770 
1771     /**
1772      * @dev See {IERC721Metadata-name}.
1773      */
1774     function name() public view virtual override returns (string memory) {
1775         return _name;
1776     }
1777 
1778     /**
1779      * @dev See {IERC721Metadata-symbol}.
1780      */
1781     function symbol() public view virtual override returns (string memory) {
1782         return _symbol;
1783     }
1784 
1785     /**
1786      * @dev See {IERC721Metadata-tokenURI}.
1787      */
1788     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1789         _requireMinted(tokenId);
1790 
1791         string memory baseURI = _baseURI();
1792         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1793     }
1794 
1795     /**
1796      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1797      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1798      * by default, can be overridden in child contracts.
1799      */
1800     function _baseURI() internal view virtual returns (string memory) {
1801         return "";
1802     }
1803 
1804     /**
1805      * @dev See {IERC721-approve}.
1806      */
1807     function approve(address to, uint256 tokenId) public virtual override {
1808         address owner = ERC721.ownerOf(tokenId);
1809         require(to != owner, "ERC721: approval to current owner");
1810 
1811         require(
1812             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1813             "ERC721: approve caller is not token owner or approved for all"
1814         );
1815 
1816         _approve(to, tokenId);
1817     }
1818 
1819     /**
1820      * @dev See {IERC721-getApproved}.
1821      */
1822     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1823         _requireMinted(tokenId);
1824 
1825         return _tokenApprovals[tokenId];
1826     }
1827 
1828     /**
1829      * @dev See {IERC721-setApprovalForAll}.
1830      */
1831     function setApprovalForAll(address operator, bool approved) public virtual override {
1832         _setApprovalForAll(_msgSender(), operator, approved);
1833     }
1834 
1835     /**
1836      * @dev See {IERC721-isApprovedForAll}.
1837      */
1838     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1839         return _operatorApprovals[owner][operator];
1840     }
1841 
1842     /**
1843      * @dev See {IERC721-transferFrom}.
1844      */
1845     function transferFrom(
1846         address from,
1847         address to,
1848         uint256 tokenId
1849     ) public virtual override {
1850         //solhint-disable-next-line max-line-length
1851         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1852 
1853         _transfer(from, to, tokenId);
1854     }
1855 
1856     /**
1857      * @dev See {IERC721-safeTransferFrom}.
1858      */
1859     function safeTransferFrom(
1860         address from,
1861         address to,
1862         uint256 tokenId
1863     ) public virtual override {
1864         safeTransferFrom(from, to, tokenId, "");
1865     }
1866 
1867     /**
1868      * @dev See {IERC721-safeTransferFrom}.
1869      */
1870     function safeTransferFrom(
1871         address from,
1872         address to,
1873         uint256 tokenId,
1874         bytes memory data
1875     ) public virtual override {
1876         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1877         _safeTransfer(from, to, tokenId, data);
1878     }
1879 
1880     /**
1881      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1882      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1883      *
1884      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1885      *
1886      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1887      * implement alternative mechanisms to perform token transfer, such as signature-based.
1888      *
1889      * Requirements:
1890      *
1891      * - `from` cannot be the zero address.
1892      * - `to` cannot be the zero address.
1893      * - `tokenId` token must exist and be owned by `from`.
1894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1895      *
1896      * Emits a {Transfer} event.
1897      */
1898     function _safeTransfer(
1899         address from,
1900         address to,
1901         uint256 tokenId,
1902         bytes memory data
1903     ) internal virtual {
1904         _transfer(from, to, tokenId);
1905         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1906     }
1907 
1908     /**
1909      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1910      */
1911     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1912         return _owners[tokenId];
1913     }
1914 
1915     /**
1916      * @dev Returns whether `tokenId` exists.
1917      *
1918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1919      *
1920      * Tokens start existing when they are minted (`_mint`),
1921      * and stop existing when they are burned (`_burn`).
1922      */
1923     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1924         return _ownerOf(tokenId) != address(0);
1925     }
1926 
1927     /**
1928      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1929      *
1930      * Requirements:
1931      *
1932      * - `tokenId` must exist.
1933      */
1934     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1935         address owner = ERC721.ownerOf(tokenId);
1936         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1937     }
1938 
1939     /**
1940      * @dev Safely mints `tokenId` and transfers it to `to`.
1941      *
1942      * Requirements:
1943      *
1944      * - `tokenId` must not exist.
1945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1946      *
1947      * Emits a {Transfer} event.
1948      */
1949     function _safeMint(address to, uint256 tokenId) internal virtual {
1950         _safeMint(to, tokenId, "");
1951     }
1952 
1953     /**
1954      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1955      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1956      */
1957     function _safeMint(
1958         address to,
1959         uint256 tokenId,
1960         bytes memory data
1961     ) internal virtual {
1962         _mint(to, tokenId);
1963         require(
1964             _checkOnERC721Received(address(0), to, tokenId, data),
1965             "ERC721: transfer to non ERC721Receiver implementer"
1966         );
1967     }
1968 
1969     /**
1970      * @dev Mints `tokenId` and transfers it to `to`.
1971      *
1972      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1973      *
1974      * Requirements:
1975      *
1976      * - `tokenId` must not exist.
1977      * - `to` cannot be the zero address.
1978      *
1979      * Emits a {Transfer} event.
1980      */
1981     function _mint(address to, uint256 tokenId) internal virtual {
1982         require(to != address(0), "ERC721: mint to the zero address");
1983         require(!_exists(tokenId), "ERC721: token already minted");
1984 
1985         _beforeTokenTransfer(address(0), to, tokenId, 1);
1986 
1987         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1988         require(!_exists(tokenId), "ERC721: token already minted");
1989 
1990         unchecked {
1991             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1992             // Given that tokens are minted one by one, it is impossible in practice that
1993             // this ever happens. Might change if we allow batch minting.
1994             // The ERC fails to describe this case.
1995             _balances[to] += 1;
1996         }
1997 
1998         _owners[tokenId] = to;
1999 
2000         emit Transfer(address(0), to, tokenId);
2001 
2002         _afterTokenTransfer(address(0), to, tokenId, 1);
2003     }
2004 
2005     /**
2006      * @dev Destroys `tokenId`.
2007      * The approval is cleared when the token is burned.
2008      * This is an internal function that does not check if the sender is authorized to operate on the token.
2009      *
2010      * Requirements:
2011      *
2012      * - `tokenId` must exist.
2013      *
2014      * Emits a {Transfer} event.
2015      */
2016     function _burn(uint256 tokenId) internal virtual {
2017         address owner = ERC721.ownerOf(tokenId);
2018 
2019         _beforeTokenTransfer(owner, address(0), tokenId, 1);
2020 
2021         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
2022         owner = ERC721.ownerOf(tokenId);
2023 
2024         // Clear approvals
2025         delete _tokenApprovals[tokenId];
2026 
2027         unchecked {
2028             // Cannot overflow, as that would require more tokens to be burned/transferred
2029             // out than the owner initially received through minting and transferring in.
2030             _balances[owner] -= 1;
2031         }
2032         delete _owners[tokenId];
2033 
2034         emit Transfer(owner, address(0), tokenId);
2035 
2036         _afterTokenTransfer(owner, address(0), tokenId, 1);
2037     }
2038 
2039     /**
2040      * @dev Transfers `tokenId` from `from` to `to`.
2041      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2042      *
2043      * Requirements:
2044      *
2045      * - `to` cannot be the zero address.
2046      * - `tokenId` token must be owned by `from`.
2047      *
2048      * Emits a {Transfer} event.
2049      */
2050     function _transfer(
2051         address from,
2052         address to,
2053         uint256 tokenId
2054     ) internal virtual {
2055         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2056         require(to != address(0), "ERC721: transfer to the zero address");
2057 
2058         _beforeTokenTransfer(from, to, tokenId, 1);
2059 
2060         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
2061         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2062 
2063         // Clear approvals from the previous owner
2064         delete _tokenApprovals[tokenId];
2065 
2066         unchecked {
2067             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
2068             // `from`'s balance is the number of token held, which is at least one before the current
2069             // transfer.
2070             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
2071             // all 2**256 token ids to be minted, which in practice is impossible.
2072             _balances[from] -= 1;
2073             _balances[to] += 1;
2074         }
2075         _owners[tokenId] = to;
2076 
2077         emit Transfer(from, to, tokenId);
2078 
2079         _afterTokenTransfer(from, to, tokenId, 1);
2080     }
2081 
2082     /**
2083      * @dev Approve `to` to operate on `tokenId`
2084      *
2085      * Emits an {Approval} event.
2086      */
2087     function _approve(address to, uint256 tokenId) internal virtual {
2088         _tokenApprovals[tokenId] = to;
2089         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2090     }
2091 
2092     /**
2093      * @dev Approve `operator` to operate on all of `owner` tokens
2094      *
2095      * Emits an {ApprovalForAll} event.
2096      */
2097     function _setApprovalForAll(
2098         address owner,
2099         address operator,
2100         bool approved
2101     ) internal virtual {
2102         require(owner != operator, "ERC721: approve to caller");
2103         _operatorApprovals[owner][operator] = approved;
2104         emit ApprovalForAll(owner, operator, approved);
2105     }
2106 
2107     /**
2108      * @dev Reverts if the `tokenId` has not been minted yet.
2109      */
2110     function _requireMinted(uint256 tokenId) internal view virtual {
2111         require(_exists(tokenId), "ERC721: invalid token ID");
2112     }
2113 
2114     /**
2115      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2116      * The call is not executed if the target address is not a contract.
2117      *
2118      * @param from address representing the previous owner of the given token ID
2119      * @param to target address that will receive the tokens
2120      * @param tokenId uint256 ID of the token to be transferred
2121      * @param data bytes optional data to send along with the call
2122      * @return bool whether the call correctly returned the expected magic value
2123      */
2124     function _checkOnERC721Received(
2125         address from,
2126         address to,
2127         uint256 tokenId,
2128         bytes memory data
2129     ) private returns (bool) {
2130         if (to.isContract()) {
2131             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2132                 return retval == IERC721Receiver.onERC721Received.selector;
2133             } catch (bytes memory reason) {
2134                 if (reason.length == 0) {
2135                     revert("ERC721: transfer to non ERC721Receiver implementer");
2136                 } else {
2137                     /// @solidity memory-safe-assembly
2138                     assembly {
2139                         revert(add(32, reason), mload(reason))
2140                     }
2141                 }
2142             }
2143         } else {
2144             return true;
2145         }
2146     }
2147 
2148     /**
2149      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2150      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2151      *
2152      * Calling conditions:
2153      *
2154      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2155      * - When `from` is zero, the tokens will be minted for `to`.
2156      * - When `to` is zero, ``from``'s tokens will be burned.
2157      * - `from` and `to` are never both zero.
2158      * - `batchSize` is non-zero.
2159      *
2160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2161      */
2162     function _beforeTokenTransfer(
2163         address from,
2164         address to,
2165         uint256, /* firstTokenId */
2166         uint256 batchSize
2167     ) internal virtual {
2168         if (batchSize > 1) {
2169             if (from != address(0)) {
2170                 _balances[from] -= batchSize;
2171             }
2172             if (to != address(0)) {
2173                 _balances[to] += batchSize;
2174             }
2175         }
2176     }
2177 
2178     /**
2179      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2180      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2181      *
2182      * Calling conditions:
2183      *
2184      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2185      * - When `from` is zero, the tokens were minted for `to`.
2186      * - When `to` is zero, ``from``'s tokens were burned.
2187      * - `from` and `to` are never both zero.
2188      * - `batchSize` is non-zero.
2189      *
2190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2191      */
2192     function _afterTokenTransfer(
2193         address from,
2194         address to,
2195         uint256 firstTokenId,
2196         uint256 batchSize
2197     ) internal virtual {}
2198 }
2199 
2200 
2201 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.8.0
2202 
2203 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
2204 
2205 pragma solidity ^0.8.0;
2206 
2207 /**
2208  * @dev ERC721 token with storage based token URI management.
2209  */
2210 abstract contract ERC721URIStorage is ERC721 {
2211     using Strings for uint256;
2212 
2213     // Optional mapping for token URIs
2214     mapping(uint256 => string) private _tokenURIs;
2215 
2216     /**
2217      * @dev See {IERC721Metadata-tokenURI}.
2218      */
2219     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2220         _requireMinted(tokenId);
2221 
2222         string memory _tokenURI = _tokenURIs[tokenId];
2223         string memory base = _baseURI();
2224 
2225         // If there is no base URI, return the token URI.
2226         if (bytes(base).length == 0) {
2227             return _tokenURI;
2228         }
2229         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2230         if (bytes(_tokenURI).length > 0) {
2231             return string(abi.encodePacked(base, _tokenURI));
2232         }
2233 
2234         return super.tokenURI(tokenId);
2235     }
2236 
2237     /**
2238      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2239      *
2240      * Requirements:
2241      *
2242      * - `tokenId` must exist.
2243      */
2244     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2245         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
2246         _tokenURIs[tokenId] = _tokenURI;
2247     }
2248 
2249     /**
2250      * @dev See {ERC721-_burn}. This override additionally checks to see if a
2251      * token-specific URI was set for the token, and if so, it deletes the token URI from
2252      * the storage mapping.
2253      */
2254     function _burn(uint256 tokenId) internal virtual override {
2255         super._burn(tokenId);
2256 
2257         if (bytes(_tokenURIs[tokenId]).length != 0) {
2258             delete _tokenURIs[tokenId];
2259         }
2260     }
2261 }
2262 
2263 
2264 // File contracts/NFTOasisV2.sol
2265 
2266 pragma solidity ^0.8.0;
2267 
2268 
2269 
2270 
2271 
2272 
2273 abstract contract NFTOasisV2 is AccessControl, ERC721URIStorage, DefaultOperatorFilterer, Ownable {
2274   bytes32 public constant ADMIN_MINTER_ROLE = keccak256("ADMIN_MINTER_ROLE");
2275 
2276   string private baseURI;
2277 
2278   address payable private _payoutAddress;
2279 
2280   uint256 private _tokenIdCounter = 1;
2281   uint256 private _totalSupply;
2282   uint256 private _normalSaleSupply;
2283   uint256 private _allowListSaleSupply;
2284 
2285   uint256 private _maxNumOfBalancePerAddress;
2286   uint256 private _maxNumOfAllowListSalePerAddress;
2287   uint256 private _maxNumOfOneMintForNormalSale;
2288   uint256 private _maxNumOfOneMintForAllowListSale;
2289   uint256 private _maxNumOfTotalSupply;
2290   // note: saleSupply is not normalSaleSupply.
2291   // saleSupply = (normalSaleSupply + allowListSaleSupply)
2292   // normalSaleSupply = saleSupply - allowListSaleSupply
2293   uint256 private _maxNumOfSaleSupply;
2294   uint256 private _maxNumOfAllowListSaleSupply;
2295 
2296   uint256 private _normalSalePrice;
2297   uint256 private _allowListSalePrice;
2298 
2299   uint256 private _normalSaleOpenDt;
2300   uint256 private _normalSaleCloseDt;
2301   uint256 private _allowListSaleOpenDt;
2302   uint256 private _allowListSaleCloseDt;
2303   uint256 private _ticketOpenDt;
2304   uint256 private _ticketCloseDt;
2305 
2306   mapping (bytes32 => bool) private _ticketBodySigToUsed;
2307   mapping (address => uint256) private _addressToAllowListSaleNum;
2308 
2309   struct MintTicket {
2310     uint256 collectionId;
2311     uint256 sigType;
2312     uint256 num;
2313     address bodySigner;
2314     bytes uuid;
2315     bytes headSig;
2316     bytes bodySig;
2317   }
2318 
2319   IApprovalProxy public approvalProxy;
2320 
2321   event MintForNormalSale(address caller, uint256 num);
2322   event MintForAllowListSale(address caller, uint256 num);
2323   event MintWithTicket(address caller, bytes bodySig, uint256 num);
2324   event UpdateSettings();
2325   event UpdateApprovalProxy(address newProxyContract);
2326 
2327   constructor (
2328     string memory name,
2329     string memory symbol,
2330     address payoutAddress_,
2331     uint256[7] memory maxNumSetting,
2332     uint256[2] memory priceSetting,
2333     uint256[6] memory openCloseSetting
2334   ) ERC721(name, symbol) {
2335     _setupRole(ADMIN_MINTER_ROLE, _msgSender());
2336 
2337     _payoutAddress = payable(payoutAddress_);
2338 
2339     _maxNumOfBalancePerAddress = maxNumSetting[0];
2340     _maxNumOfAllowListSalePerAddress = maxNumSetting[1];
2341     _maxNumOfOneMintForNormalSale = maxNumSetting[2];
2342     _maxNumOfOneMintForAllowListSale = maxNumSetting[3];
2343     _maxNumOfTotalSupply = maxNumSetting[4];
2344     _maxNumOfSaleSupply = maxNumSetting[5];
2345     _maxNumOfAllowListSaleSupply = maxNumSetting[6];
2346 
2347     _normalSalePrice = priceSetting[0];
2348     _allowListSalePrice = priceSetting[1];
2349 
2350     _normalSaleOpenDt = openCloseSetting[0];
2351     _normalSaleCloseDt = openCloseSetting[1];
2352     _allowListSaleOpenDt = openCloseSetting[2];
2353     _allowListSaleCloseDt = openCloseSetting[3];
2354     _ticketOpenDt = openCloseSetting[4];
2355     _ticketCloseDt = openCloseSetting[5];
2356   }
2357 
2358   modifier supplyLimited(uint256 num) {
2359     require((_totalSupply + num) <= _maxNumOfTotalSupply);
2360     _;
2361   }
2362 
2363   modifier mintNumberLimited(uint256 num, uint256 max) {
2364     require(0 < num && num <= max);
2365     _;
2366   }
2367 
2368   modifier possessionNumberLimited(uint256 num) {
2369     require(_maxNumOfBalancePerAddress == 0 || (balanceOf(msg.sender) + num) <= _maxNumOfBalancePerAddress);
2370     _;
2371   }
2372 
2373   modifier amountLimited(uint256 amount) {
2374     require(msg.value == amount);
2375     _;
2376   }
2377 
2378   modifier periodLimited(uint256 openDt, uint256 closeDt, bool allowZero) {
2379     if (allowZero) {
2380       require(openDt == 0 || openDt <= block.timestamp);
2381       require(closeDt == 0 || block.timestamp <= closeDt);
2382     } else {
2383       require(openDt <= block.timestamp && block.timestamp <= closeDt);
2384     }
2385     _;
2386   }
2387 
2388   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2389     super.transferFrom(from, to, tokenId);
2390   }
2391 
2392   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2393     super.safeTransferFrom(from, to, tokenId);
2394   }
2395 
2396   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2397       public
2398       override
2399       onlyAllowedOperator(from)
2400   {
2401     super.safeTransferFrom(from, to, tokenId, data);
2402   }
2403 
2404   function mint(address to, uint256 tokenId)
2405     public
2406     supplyLimited(1)
2407   {
2408     require(
2409       hasRole(ADMIN_MINTER_ROLE, _msgSender()),
2410       "ERC721Mintble: must have minter role to mint"
2411     );
2412     _mint(to, tokenId);
2413     _totalSupply++;
2414   }
2415 
2416   function mint(address[] memory toList, uint256[] memory tokenIdList)
2417     external
2418     supplyLimited(tokenIdList.length)
2419   {
2420     require(
2421       toList.length == tokenIdList.length,
2422       "input length must be same"
2423     );
2424     for (uint256 i = 0; i < tokenIdList.length; i++) {
2425       mint(toList[i], tokenIdList[i]);
2426     }
2427   }
2428 
2429   function mintFor(address to, uint256 tokenId) public {
2430     mint(to, tokenId);
2431   }
2432 
2433   /**
2434    * @dev See {IERC721Metadata-tokenURI}.
2435    */
2436   function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
2437     return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2438   }
2439 
2440   function setBaseURI(string memory __baseURI) external onlyOwner {
2441     baseURI = __baseURI;
2442   }
2443 
2444   function exists(uint256 tokenId) public view returns(bool) {
2445     return _exists(tokenId);
2446   }
2447 
2448   function setApprovalProxy(address _new) public onlyOwner {
2449     approvalProxy = IApprovalProxy(_new);
2450     emit UpdateApprovalProxy(_new);
2451   }
2452 
2453   function setApprovalForAll(address spender, bool approved) public virtual override {
2454     if (address(approvalProxy) != address(0x0) && Address.isContract(spender)) {
2455       approvalProxy.setApprovalForAll(msg.sender, spender, approved);
2456     }
2457     super.setApprovalForAll(spender, approved);
2458   }
2459 
2460   function isApprovedForAll(address owner, address spender) public view override returns(bool) {
2461     bool approved = super.isApprovedForAll(owner, spender);
2462     if (address(approvalProxy) != address(0x0)) {
2463       return approvalProxy.isApprovedForAll(owner, spender, approved);
2464     }
2465     return approved;
2466   }
2467 
2468   function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC721) returns(bool) {
2469     return AccessControl.supportsInterface(interfaceId) || ERC721.supportsInterface(interfaceId);
2470   }
2471 
2472   function _baseURI() internal view override returns(string memory) {
2473     if (bytes(baseURI).length > 0) {
2474       return baseURI;
2475     }
2476     return string(abi.encodePacked(
2477       "https://nft.financie.io/metadata/",
2478       symbol(),
2479       "/"
2480     ));
2481   }
2482 
2483   function mintForNormalSale(uint256 num)
2484     public
2485     payable
2486     mintNumberLimited(num, _maxNumOfOneMintForNormalSale)
2487     possessionNumberLimited(num)
2488     amountLimited(_normalSalePrice * num)
2489     periodLimited(_normalSaleOpenDt, _normalSaleCloseDt, true)
2490     supplyLimited(num)
2491   {
2492     require((_allowListSaleSupply + _normalSaleSupply + num) <= _maxNumOfSaleSupply);
2493     _mintTokens(num);
2494     _normalSaleSupply += num;
2495     _payoutAddress.transfer(msg.value);
2496     emit MintForNormalSale(msg.sender, num);
2497   }
2498 
2499   function mintForAllowListSale(MintTicket calldata mintTicket)
2500     public
2501     payable
2502     mintNumberLimited(mintTicket.num, _maxNumOfOneMintForAllowListSale)
2503     possessionNumberLimited(mintTicket.num)
2504     amountLimited(_allowListSalePrice * mintTicket.num)
2505     periodLimited(_allowListSaleOpenDt, _allowListSaleCloseDt, false)
2506     supplyLimited(mintTicket.num)
2507   {
2508     require(mintTicket.sigType == 0);
2509     require((_addressToAllowListSaleNum[msg.sender] + mintTicket.num) <= _maxNumOfAllowListSalePerAddress);
2510     require((_allowListSaleSupply + mintTicket.num) <= _maxNumOfAllowListSaleSupply);
2511 
2512     _mintWithTicket(mintTicket);
2513     _allowListSaleSupply += mintTicket.num;
2514     _addressToAllowListSaleNum[msg.sender] += mintTicket.num;
2515     _payoutAddress.transfer(msg.value);
2516     emit MintForAllowListSale(msg.sender, mintTicket.num);
2517   }
2518 
2519   function mintWithTicket(MintTicket calldata mintTicket)
2520     public
2521     periodLimited(_ticketOpenDt, _ticketCloseDt, true)
2522     supplyLimited(mintTicket.num)
2523   {
2524     require(mintTicket.sigType == 1 || mintTicket.sigType == 2);
2525 
2526     _mintWithTicket(mintTicket);
2527     _ticketBodySigToUsed[keccak256(mintTicket.bodySig)] = true;
2528     emit MintWithTicket(msg.sender, mintTicket.bodySig, mintTicket.num);
2529   }
2530 
2531   function mintWithTicketMultiple(MintTicket[] calldata mintTickets) public {
2532     for (uint256 i = 0; i < mintTickets.length; i++) {
2533       mintWithTicket(mintTickets[i]);
2534     }
2535   }
2536 
2537   function _mintWithTicket(MintTicket calldata mintTicket) private {
2538     require(mintTicket.num > 0);
2539     require(!_ticketBodySigToUsed[keccak256(mintTicket.bodySig)]);
2540 
2541     (address headSigner, address bodySigner) = _recoverSigners(mintTicket);
2542     require(headSigner == owner() && bodySigner == mintTicket.bodySigner, "invalid signanature");
2543 
2544     _mintTokens(mintTicket.num);
2545   }
2546 
2547   function _recoverSigners(MintTicket calldata mintTicket) private view returns(address, address) {
2548     require(mintTicket.sigType == 0 || mintTicket.sigType == 1 || mintTicket.sigType == 2);
2549 
2550     string memory signedMessage = "\x19Ethereum Signed Message:\n32";
2551 
2552     bytes32 headHash = keccak256(abi.encodePacked(
2553       signedMessage,
2554       keccak256(abi.encodePacked(mintTicket.bodySigner))
2555     ));
2556     address headSigner = ECDSA.recover(headHash, mintTicket.headSig);
2557     bytes32 bodyHash;
2558     if (mintTicket.sigType == 0) {
2559       bodyHash = keccak256(abi.encodePacked(
2560         signedMessage,
2561         keccak256(abi.encodePacked(mintTicket.sigType, mintTicket.collectionId, mintTicket.uuid, msg.sender))
2562       ));
2563     } else if(mintTicket.sigType == 1) {
2564       bodyHash = keccak256(abi.encodePacked(
2565         signedMessage,
2566         keccak256(abi.encodePacked(mintTicket.sigType, mintTicket.collectionId, mintTicket.uuid, mintTicket.num))
2567       ));
2568     } else {
2569       // sigType == 2
2570       bodyHash = keccak256(abi.encodePacked(
2571         signedMessage,
2572         keccak256(abi.encodePacked(mintTicket.sigType, mintTicket.collectionId, mintTicket.uuid, mintTicket.num, msg.sender))
2573       ));
2574     }
2575     address bodySigner = ECDSA.recover(bodyHash, mintTicket.bodySig);
2576 
2577     return (headSigner, bodySigner);
2578   }
2579 
2580   function _mintTokens(uint256 num) private {
2581     uint256 mintCount = 0;
2582     uint256 tokenCount = 0;
2583     uint256 computedTokenId = _tokenIdCounter + tokenCount;
2584 
2585     while (mintCount < num) {
2586       while(_exists(computedTokenId)) {
2587         tokenCount++;
2588         computedTokenId = _tokenIdCounter + tokenCount;
2589       }
2590       _mint(_msgSender(), computedTokenId);
2591       mintCount++;
2592     }
2593     _totalSupply += num;
2594     _tokenIdCounter = computedTokenId + 1;
2595   }
2596 
2597   function updateSettings(
2598     address payoutAddress_,
2599     uint256[7] memory maxNumSetting,
2600     uint256[2] memory priceSetting,
2601     uint256[6] memory openCloseSetting
2602   ) public onlyOwner {
2603     _payoutAddress = payable(payoutAddress_);
2604 
2605     _maxNumOfBalancePerAddress = maxNumSetting[0];
2606     _maxNumOfAllowListSalePerAddress = maxNumSetting[1];
2607     _maxNumOfOneMintForNormalSale = maxNumSetting[2];
2608     _maxNumOfOneMintForAllowListSale = maxNumSetting[3];
2609     _maxNumOfTotalSupply = maxNumSetting[4];
2610     _maxNumOfSaleSupply = maxNumSetting[5];
2611     _maxNumOfAllowListSaleSupply = maxNumSetting[6];
2612 
2613     _normalSalePrice = priceSetting[0];
2614     _allowListSalePrice = priceSetting[1];
2615 
2616     _normalSaleOpenDt = openCloseSetting[0];
2617     _normalSaleCloseDt = openCloseSetting[1];
2618     _allowListSaleOpenDt = openCloseSetting[2];
2619     _allowListSaleCloseDt = openCloseSetting[3];
2620     _ticketOpenDt = openCloseSetting[4];
2621     _ticketCloseDt = openCloseSetting[5];
2622 
2623     emit UpdateSettings();
2624   }
2625 
2626   function isUsedTicket(bytes calldata ticketBodySig) public view returns(bool) {
2627     return _ticketBodySigToUsed[keccak256(ticketBodySig)];
2628   }
2629 
2630   function allowListSaleNum(address owner) public view returns(uint256) {
2631     return _addressToAllowListSaleNum[owner];
2632   }
2633 
2634   function payoutAddress() public view returns(address) {
2635     return _payoutAddress;
2636   }
2637 
2638   function totalSupply() public view returns(uint256) {
2639     return _totalSupply;
2640   }
2641 
2642   function normalSaleSupply() public view returns(uint256) {
2643     return _normalSaleSupply;
2644   }
2645 
2646   function allowListSaleSupply() public view returns(uint256) {
2647     return _allowListSaleSupply;
2648   }
2649 
2650   function getMaxNumSetting() public view returns(uint256[7] memory) {
2651     return [
2652       _maxNumOfBalancePerAddress,
2653       _maxNumOfAllowListSalePerAddress,
2654       _maxNumOfOneMintForNormalSale,
2655       _maxNumOfOneMintForAllowListSale,
2656       _maxNumOfTotalSupply,
2657       _maxNumOfSaleSupply,
2658       _maxNumOfAllowListSaleSupply
2659     ];
2660   }
2661 
2662   function getPriceSetting() public view returns(uint256[2] memory) {
2663     return [
2664       _normalSalePrice,
2665       _allowListSalePrice
2666     ];
2667   }
2668 
2669   function getOpenCloseSetting() public view returns(uint256[6] memory) {
2670     return [
2671       _normalSaleOpenDt,
2672       _normalSaleCloseDt,
2673       _allowListSaleOpenDt,
2674       _allowListSaleCloseDt,
2675       _ticketOpenDt,
2676       _ticketCloseDt
2677     ];
2678   }
2679 }
2680 
2681 
2682 // File contracts/NFTokenV2.sol
2683 
2684 pragma solidity ^0.8.0;
2685 
2686 contract supersapienssnft is NFTOasisV2 {
2687   constructor() NFTOasisV2(
2688     "supersapienssnft",
2689     "supersapienssnft",
2690     address(0x81c476a7B5ce987E3A1D74C0A44Df2ce46F8c74b),
2691     [
2692       uint256(0),
2693       5,
2694       5,
2695       5,
2696       7000,
2697       6465,
2698       5465
2699     ],
2700     [
2701       uint256(80000000000000000),
2702       50000000000000000
2703     ],
2704     [
2705       uint256(1671505200),
2706       1671591600,
2707       1671253200,
2708       1671337800,
2709       1671253200,
2710       1675177140
2711     ]
2712   ) {}
2713 }