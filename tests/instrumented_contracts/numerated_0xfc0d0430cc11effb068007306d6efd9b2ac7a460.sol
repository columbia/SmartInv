1 // File: opensea/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator)
8         external
9         view
10         returns (bool);
11 
12     function register(address registrant) external;
13 
14     function registerAndSubscribe(address registrant, address subscription)
15         external;
16 
17     function registerAndCopyEntries(
18         address registrant,
19         address registrantToCopy
20     ) external;
21 
22     function updateOperator(
23         address registrant,
24         address operator,
25         bool filtered
26     ) external;
27 
28     function updateOperators(
29         address registrant,
30         address[] calldata operators,
31         bool filtered
32     ) external;
33 
34     function updateCodeHash(
35         address registrant,
36         bytes32 codehash,
37         bool filtered
38     ) external;
39 
40     function updateCodeHashes(
41         address registrant,
42         bytes32[] calldata codeHashes,
43         bool filtered
44     ) external;
45 
46     function subscribe(address registrant, address registrantToSubscribe)
47         external;
48 
49     function unsubscribe(address registrant, bool copyExistingEntries) external;
50 
51     function subscriptionOf(address addr) external returns (address registrant);
52 
53     function subscribers(address registrant)
54         external
55         returns (address[] memory);
56 
57     function subscriberAt(address registrant, uint256 index)
58         external
59         returns (address);
60 
61     function copyEntriesOf(address registrant, address registrantToCopy)
62         external;
63 
64     function isOperatorFiltered(address registrant, address operator)
65         external
66         returns (bool);
67 
68     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
69         external
70         returns (bool);
71 
72     function isCodeHashFiltered(address registrant, bytes32 codeHash)
73         external
74         returns (bool);
75 
76     function filteredOperators(address addr)
77         external
78         returns (address[] memory);
79 
80     function filteredCodeHashes(address addr)
81         external
82         returns (bytes32[] memory);
83 
84     function filteredOperatorAt(address registrant, uint256 index)
85         external
86         returns (address);
87 
88     function filteredCodeHashAt(address registrant, uint256 index)
89         external
90         returns (bytes32);
91 
92     function isRegistered(address addr) external returns (bool);
93 
94     function codeHashOf(address addr) external returns (bytes32);
95 }
96 
97 // File: opensea/OperatorFilterer.sol
98 
99 
100 pragma solidity ^0.8.13;
101 
102 
103 abstract contract OperatorFilterer {
104     error OperatorNotAllowed(address operator);
105 
106     IOperatorFilterRegistry constant operatorFilterRegistry =
107         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
108 
109     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
110         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
111         // will not revert, but the contract will need to be registered with the registry once it is deployed in
112         // order for the modifier to filter addresses.
113         if (address(operatorFilterRegistry).code.length > 0) {
114             if (subscribe) {
115                 operatorFilterRegistry.registerAndSubscribe(
116                     address(this),
117                     subscriptionOrRegistrantToCopy
118                 );
119             } else {
120                 if (subscriptionOrRegistrantToCopy != address(0)) {
121                     operatorFilterRegistry.registerAndCopyEntries(
122                         address(this),
123                         subscriptionOrRegistrantToCopy
124                     );
125                 } else {
126                     operatorFilterRegistry.register(address(this));
127                 }
128             }
129         }
130     }
131 
132     modifier onlyAllowedOperator(address from) virtual {
133         // Check registry code length to facilitate testing in environments without a deployed registry.
134         if (address(operatorFilterRegistry).code.length > 0) {
135             // Allow spending tokens from addresses with balance
136             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
137             // from an EOA.
138             if (from == msg.sender) {
139                 _;
140                 return;
141             }
142             if (
143                 !(operatorFilterRegistry.isOperatorAllowed(
144                     address(this),
145                     msg.sender
146                 ) &&
147                     operatorFilterRegistry.isOperatorAllowed(
148                         address(this),
149                         from
150                     ))
151             ) {
152                 revert OperatorNotAllowed(msg.sender);
153             }
154         }
155         _;
156     }
157 }
158 
159 // File: opensea/DefaultOperatorFilterer.sol
160 
161 
162 pragma solidity ^0.8.13;
163 
164 
165 abstract contract DefaultOperatorFilterer is OperatorFilterer {
166     address constant DEFAULT_SUBSCRIPTION =
167         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
168 
169     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
170 }
171 
172 // File: IKEY3.sol
173 
174 
175 pragma solidity ^0.8.9;
176 
177 interface IKEY3 {
178     // Logged when the owner of a node assigns a new owner to a subnode.
179     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
180 
181     // Logged when the owner of a node transfers ownership to a new account.
182     event Transfer(bytes32 indexed node, address owner);
183 
184     // Logged when the resolver for a node changes.
185     event NewResolver(bytes32 indexed node, address resolver);
186 
187     // Logged when the TTL of a node changes
188     event NewTTL(bytes32 indexed node, uint64 ttl);
189 
190     // Logged when an operator is added or removed.
191     event ApprovalForAll(
192         address indexed owner,
193         address indexed operator,
194         bool approved
195     );
196 
197     function setRecord(
198         bytes32 node,
199         address owner,
200         address resolver,
201         uint64 ttl
202     ) external;
203 
204     function setSubnodeRecord(
205         bytes32 node,
206         bytes32 label,
207         address owner,
208         address resolver,
209         uint64 ttl
210     ) external;
211 
212     function setSubnodeOwner(
213         bytes32 node,
214         bytes32 label,
215         address owner
216     ) external returns (bytes32);
217 
218     function setResolver(bytes32 node, address resolver) external;
219 
220     function setOwner(bytes32 node, address owner) external;
221 
222     function setTTL(bytes32 node, uint64 ttl) external;
223 
224     function setApprovalForAll(address operator, bool approved) external;
225 
226     function owner(bytes32 node) external view returns (address);
227 
228     function resolver(bytes32 node) external view returns (address);
229 
230     function ttl(bytes32 node) external view returns (uint64);
231 
232     function recordExists(bytes32 node) external view returns (bool);
233 
234     function isApprovedForAll(address owner, address operator)
235         external
236         view
237         returns (bool);
238 }
239 
240 // File: @openzeppelin/contracts/utils/math/Math.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Standard math utilities missing in the Solidity language.
249  */
250 library Math {
251     enum Rounding {
252         Down, // Toward negative infinity
253         Up, // Toward infinity
254         Zero // Toward zero
255     }
256 
257     /**
258      * @dev Returns the largest of two numbers.
259      */
260     function max(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a > b ? a : b;
262     }
263 
264     /**
265      * @dev Returns the smallest of two numbers.
266      */
267     function min(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a < b ? a : b;
269     }
270 
271     /**
272      * @dev Returns the average of two numbers. The result is rounded towards
273      * zero.
274      */
275     function average(uint256 a, uint256 b) internal pure returns (uint256) {
276         // (a + b) / 2 can overflow.
277         return (a & b) + (a ^ b) / 2;
278     }
279 
280     /**
281      * @dev Returns the ceiling of the division of two numbers.
282      *
283      * This differs from standard division with `/` in that it rounds up instead
284      * of rounding down.
285      */
286     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
287         // (a + b - 1) / b can overflow on addition, so we distribute.
288         return a == 0 ? 0 : (a - 1) / b + 1;
289     }
290 
291     /**
292      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
293      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
294      * with further edits by Uniswap Labs also under MIT license.
295      */
296     function mulDiv(
297         uint256 x,
298         uint256 y,
299         uint256 denominator
300     ) internal pure returns (uint256 result) {
301         unchecked {
302             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
303             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
304             // variables such that product = prod1 * 2^256 + prod0.
305             uint256 prod0; // Least significant 256 bits of the product
306             uint256 prod1; // Most significant 256 bits of the product
307             assembly {
308                 let mm := mulmod(x, y, not(0))
309                 prod0 := mul(x, y)
310                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
311             }
312 
313             // Handle non-overflow cases, 256 by 256 division.
314             if (prod1 == 0) {
315                 return prod0 / denominator;
316             }
317 
318             // Make sure the result is less than 2^256. Also prevents denominator == 0.
319             require(denominator > prod1);
320 
321             ///////////////////////////////////////////////
322             // 512 by 256 division.
323             ///////////////////////////////////////////////
324 
325             // Make division exact by subtracting the remainder from [prod1 prod0].
326             uint256 remainder;
327             assembly {
328                 // Compute remainder using mulmod.
329                 remainder := mulmod(x, y, denominator)
330 
331                 // Subtract 256 bit number from 512 bit number.
332                 prod1 := sub(prod1, gt(remainder, prod0))
333                 prod0 := sub(prod0, remainder)
334             }
335 
336             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
337             // See https://cs.stackexchange.com/q/138556/92363.
338 
339             // Does not overflow because the denominator cannot be zero at this stage in the function.
340             uint256 twos = denominator & (~denominator + 1);
341             assembly {
342                 // Divide denominator by twos.
343                 denominator := div(denominator, twos)
344 
345                 // Divide [prod1 prod0] by twos.
346                 prod0 := div(prod0, twos)
347 
348                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
349                 twos := add(div(sub(0, twos), twos), 1)
350             }
351 
352             // Shift in bits from prod1 into prod0.
353             prod0 |= prod1 * twos;
354 
355             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
356             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
357             // four bits. That is, denominator * inv = 1 mod 2^4.
358             uint256 inverse = (3 * denominator) ^ 2;
359 
360             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
361             // in modular arithmetic, doubling the correct bits in each step.
362             inverse *= 2 - denominator * inverse; // inverse mod 2^8
363             inverse *= 2 - denominator * inverse; // inverse mod 2^16
364             inverse *= 2 - denominator * inverse; // inverse mod 2^32
365             inverse *= 2 - denominator * inverse; // inverse mod 2^64
366             inverse *= 2 - denominator * inverse; // inverse mod 2^128
367             inverse *= 2 - denominator * inverse; // inverse mod 2^256
368 
369             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
370             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
371             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
372             // is no longer required.
373             result = prod0 * inverse;
374             return result;
375         }
376     }
377 
378     /**
379      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
380      */
381     function mulDiv(
382         uint256 x,
383         uint256 y,
384         uint256 denominator,
385         Rounding rounding
386     ) internal pure returns (uint256) {
387         uint256 result = mulDiv(x, y, denominator);
388         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
389             result += 1;
390         }
391         return result;
392     }
393 
394     /**
395      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
396      *
397      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
398      */
399     function sqrt(uint256 a) internal pure returns (uint256) {
400         if (a == 0) {
401             return 0;
402         }
403 
404         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
405         //
406         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
407         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
408         //
409         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
410         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
411         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
412         //
413         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
414         uint256 result = 1 << (log2(a) >> 1);
415 
416         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
417         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
418         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
419         // into the expected uint128 result.
420         unchecked {
421             result = (result + a / result) >> 1;
422             result = (result + a / result) >> 1;
423             result = (result + a / result) >> 1;
424             result = (result + a / result) >> 1;
425             result = (result + a / result) >> 1;
426             result = (result + a / result) >> 1;
427             result = (result + a / result) >> 1;
428             return min(result, a / result);
429         }
430     }
431 
432     /**
433      * @notice Calculates sqrt(a), following the selected rounding direction.
434      */
435     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
436         unchecked {
437             uint256 result = sqrt(a);
438             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
439         }
440     }
441 
442     /**
443      * @dev Return the log in base 2, rounded down, of a positive value.
444      * Returns 0 if given 0.
445      */
446     function log2(uint256 value) internal pure returns (uint256) {
447         uint256 result = 0;
448         unchecked {
449             if (value >> 128 > 0) {
450                 value >>= 128;
451                 result += 128;
452             }
453             if (value >> 64 > 0) {
454                 value >>= 64;
455                 result += 64;
456             }
457             if (value >> 32 > 0) {
458                 value >>= 32;
459                 result += 32;
460             }
461             if (value >> 16 > 0) {
462                 value >>= 16;
463                 result += 16;
464             }
465             if (value >> 8 > 0) {
466                 value >>= 8;
467                 result += 8;
468             }
469             if (value >> 4 > 0) {
470                 value >>= 4;
471                 result += 4;
472             }
473             if (value >> 2 > 0) {
474                 value >>= 2;
475                 result += 2;
476             }
477             if (value >> 1 > 0) {
478                 result += 1;
479             }
480         }
481         return result;
482     }
483 
484     /**
485      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
486      * Returns 0 if given 0.
487      */
488     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
489         unchecked {
490             uint256 result = log2(value);
491             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
492         }
493     }
494 
495     /**
496      * @dev Return the log in base 10, rounded down, of a positive value.
497      * Returns 0 if given 0.
498      */
499     function log10(uint256 value) internal pure returns (uint256) {
500         uint256 result = 0;
501         unchecked {
502             if (value >= 10**64) {
503                 value /= 10**64;
504                 result += 64;
505             }
506             if (value >= 10**32) {
507                 value /= 10**32;
508                 result += 32;
509             }
510             if (value >= 10**16) {
511                 value /= 10**16;
512                 result += 16;
513             }
514             if (value >= 10**8) {
515                 value /= 10**8;
516                 result += 8;
517             }
518             if (value >= 10**4) {
519                 value /= 10**4;
520                 result += 4;
521             }
522             if (value >= 10**2) {
523                 value /= 10**2;
524                 result += 2;
525             }
526             if (value >= 10**1) {
527                 result += 1;
528             }
529         }
530         return result;
531     }
532 
533     /**
534      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
535      * Returns 0 if given 0.
536      */
537     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
538         unchecked {
539             uint256 result = log10(value);
540             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
541         }
542     }
543 
544     /**
545      * @dev Return the log in base 256, rounded down, of a positive value.
546      * Returns 0 if given 0.
547      *
548      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
549      */
550     function log256(uint256 value) internal pure returns (uint256) {
551         uint256 result = 0;
552         unchecked {
553             if (value >> 128 > 0) {
554                 value >>= 128;
555                 result += 16;
556             }
557             if (value >> 64 > 0) {
558                 value >>= 64;
559                 result += 8;
560             }
561             if (value >> 32 > 0) {
562                 value >>= 32;
563                 result += 4;
564             }
565             if (value >> 16 > 0) {
566                 value >>= 16;
567                 result += 2;
568             }
569             if (value >> 8 > 0) {
570                 result += 1;
571             }
572         }
573         return result;
574     }
575 
576     /**
577      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
578      * Returns 0 if given 0.
579      */
580     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
581         unchecked {
582             uint256 result = log256(value);
583             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
584         }
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/Strings.sol
589 
590 
591 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev String operations.
598  */
599 library Strings {
600     bytes16 private constant _SYMBOLS = "0123456789abcdef";
601     uint8 private constant _ADDRESS_LENGTH = 20;
602 
603     /**
604      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
605      */
606     function toString(uint256 value) internal pure returns (string memory) {
607         unchecked {
608             uint256 length = Math.log10(value) + 1;
609             string memory buffer = new string(length);
610             uint256 ptr;
611             /// @solidity memory-safe-assembly
612             assembly {
613                 ptr := add(buffer, add(32, length))
614             }
615             while (true) {
616                 ptr--;
617                 /// @solidity memory-safe-assembly
618                 assembly {
619                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
620                 }
621                 value /= 10;
622                 if (value == 0) break;
623             }
624             return buffer;
625         }
626     }
627 
628     /**
629      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
630      */
631     function toHexString(uint256 value) internal pure returns (string memory) {
632         unchecked {
633             return toHexString(value, Math.log256(value) + 1);
634         }
635     }
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
639      */
640     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
641         bytes memory buffer = new bytes(2 * length + 2);
642         buffer[0] = "0";
643         buffer[1] = "x";
644         for (uint256 i = 2 * length + 1; i > 1; --i) {
645             buffer[i] = _SYMBOLS[value & 0xf];
646             value >>= 4;
647         }
648         require(value == 0, "Strings: hex length insufficient");
649         return string(buffer);
650     }
651 
652     /**
653      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
654      */
655     function toHexString(address addr) internal pure returns (string memory) {
656         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
657     }
658 }
659 
660 // File: @openzeppelin/contracts/utils/Context.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @dev Provides information about the current execution context, including the
669  * sender of the transaction and its data. While these are generally available
670  * via msg.sender and msg.data, they should not be accessed in such a direct
671  * manner, since when dealing with meta-transactions the account sending and
672  * paying for execution may not be the actual sender (as far as an application
673  * is concerned).
674  *
675  * This contract is only required for intermediate, library-like contracts.
676  */
677 abstract contract Context {
678     function _msgSender() internal view virtual returns (address) {
679         return msg.sender;
680     }
681 
682     function _msgData() internal view virtual returns (bytes calldata) {
683         return msg.data;
684     }
685 }
686 
687 // File: access/Controllable.sol
688 
689 
690 pragma solidity ^0.8.9;
691 
692 
693 contract Controllable is Context {
694     mapping(address => bool) public controllers;
695 
696     event ControllerAdded(address indexed controller);
697     event ControllerRemoved(address indexed controller);
698 
699     modifier onlyController() {
700         require(controllers[_msgSender()]);
701         _;
702     }
703 
704     function _addController(address controller_) internal virtual {
705         controllers[controller_] = true;
706         emit ControllerAdded(controller_);
707     }
708 
709     function _removeController(address controller_) internal virtual {
710         controllers[controller_] = false;
711         emit ControllerRemoved(controller_);
712     }
713 }
714 
715 // File: @openzeppelin/contracts/access/Ownable.sol
716 
717 
718 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Contract module which provides a basic access control mechanism, where
725  * there is an account (an owner) that can be granted exclusive access to
726  * specific functions.
727  *
728  * By default, the owner account will be the one that deploys the contract. This
729  * can later be changed with {transferOwnership}.
730  *
731  * This module is used through inheritance. It will make available the modifier
732  * `onlyOwner`, which can be applied to your functions to restrict their use to
733  * the owner.
734  */
735 abstract contract Ownable is Context {
736     address private _owner;
737 
738     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
739 
740     /**
741      * @dev Initializes the contract setting the deployer as the initial owner.
742      */
743     constructor() {
744         _transferOwnership(_msgSender());
745     }
746 
747     /**
748      * @dev Throws if called by any account other than the owner.
749      */
750     modifier onlyOwner() {
751         _checkOwner();
752         _;
753     }
754 
755     /**
756      * @dev Returns the address of the current owner.
757      */
758     function owner() public view virtual returns (address) {
759         return _owner;
760     }
761 
762     /**
763      * @dev Throws if the sender is not the owner.
764      */
765     function _checkOwner() internal view virtual {
766         require(owner() == _msgSender(), "Ownable: caller is not the owner");
767     }
768 
769     /**
770      * @dev Leaves the contract without owner. It will not be possible to call
771      * `onlyOwner` functions anymore. Can only be called by the current owner.
772      *
773      * NOTE: Renouncing ownership will leave the contract without an owner,
774      * thereby removing any functionality that is only available to the owner.
775      */
776     function renounceOwnership() public virtual onlyOwner {
777         _transferOwnership(address(0));
778     }
779 
780     /**
781      * @dev Transfers ownership of the contract to a new account (`newOwner`).
782      * Can only be called by the current owner.
783      */
784     function transferOwnership(address newOwner) public virtual onlyOwner {
785         require(newOwner != address(0), "Ownable: new owner is the zero address");
786         _transferOwnership(newOwner);
787     }
788 
789     /**
790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
791      * Internal function without access restriction.
792      */
793     function _transferOwnership(address newOwner) internal virtual {
794         address oldOwner = _owner;
795         _owner = newOwner;
796         emit OwnershipTransferred(oldOwner, newOwner);
797     }
798 }
799 
800 // File: @openzeppelin/contracts/utils/Address.sol
801 
802 
803 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
804 
805 pragma solidity ^0.8.1;
806 
807 /**
808  * @dev Collection of functions related to the address type
809  */
810 library Address {
811     /**
812      * @dev Returns true if `account` is a contract.
813      *
814      * [IMPORTANT]
815      * ====
816      * It is unsafe to assume that an address for which this function returns
817      * false is an externally-owned account (EOA) and not a contract.
818      *
819      * Among others, `isContract` will return false for the following
820      * types of addresses:
821      *
822      *  - an externally-owned account
823      *  - a contract in construction
824      *  - an address where a contract will be created
825      *  - an address where a contract lived, but was destroyed
826      * ====
827      *
828      * [IMPORTANT]
829      * ====
830      * You shouldn't rely on `isContract` to protect against flash loan attacks!
831      *
832      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
833      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
834      * constructor.
835      * ====
836      */
837     function isContract(address account) internal view returns (bool) {
838         // This method relies on extcodesize/address.code.length, which returns 0
839         // for contracts in construction, since the code is only stored at the end
840         // of the constructor execution.
841 
842         return account.code.length > 0;
843     }
844 
845     /**
846      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
847      * `recipient`, forwarding all available gas and reverting on errors.
848      *
849      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
850      * of certain opcodes, possibly making contracts go over the 2300 gas limit
851      * imposed by `transfer`, making them unable to receive funds via
852      * `transfer`. {sendValue} removes this limitation.
853      *
854      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
855      *
856      * IMPORTANT: because control is transferred to `recipient`, care must be
857      * taken to not create reentrancy vulnerabilities. Consider using
858      * {ReentrancyGuard} or the
859      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
860      */
861     function sendValue(address payable recipient, uint256 amount) internal {
862         require(address(this).balance >= amount, "Address: insufficient balance");
863 
864         (bool success, ) = recipient.call{value: amount}("");
865         require(success, "Address: unable to send value, recipient may have reverted");
866     }
867 
868     /**
869      * @dev Performs a Solidity function call using a low level `call`. A
870      * plain `call` is an unsafe replacement for a function call: use this
871      * function instead.
872      *
873      * If `target` reverts with a revert reason, it is bubbled up by this
874      * function (like regular Solidity function calls).
875      *
876      * Returns the raw returned data. To convert to the expected return value,
877      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
878      *
879      * Requirements:
880      *
881      * - `target` must be a contract.
882      * - calling `target` with `data` must not revert.
883      *
884      * _Available since v3.1._
885      */
886     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
887         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
888     }
889 
890     /**
891      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
892      * `errorMessage` as a fallback revert reason when `target` reverts.
893      *
894      * _Available since v3.1._
895      */
896     function functionCall(
897         address target,
898         bytes memory data,
899         string memory errorMessage
900     ) internal returns (bytes memory) {
901         return functionCallWithValue(target, data, 0, errorMessage);
902     }
903 
904     /**
905      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
906      * but also transferring `value` wei to `target`.
907      *
908      * Requirements:
909      *
910      * - the calling contract must have an ETH balance of at least `value`.
911      * - the called Solidity function must be `payable`.
912      *
913      * _Available since v3.1._
914      */
915     function functionCallWithValue(
916         address target,
917         bytes memory data,
918         uint256 value
919     ) internal returns (bytes memory) {
920         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
921     }
922 
923     /**
924      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
925      * with `errorMessage` as a fallback revert reason when `target` reverts.
926      *
927      * _Available since v3.1._
928      */
929     function functionCallWithValue(
930         address target,
931         bytes memory data,
932         uint256 value,
933         string memory errorMessage
934     ) internal returns (bytes memory) {
935         require(address(this).balance >= value, "Address: insufficient balance for call");
936         (bool success, bytes memory returndata) = target.call{value: value}(data);
937         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
938     }
939 
940     /**
941      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
942      * but performing a static call.
943      *
944      * _Available since v3.3._
945      */
946     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
947         return functionStaticCall(target, data, "Address: low-level static call failed");
948     }
949 
950     /**
951      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
952      * but performing a static call.
953      *
954      * _Available since v3.3._
955      */
956     function functionStaticCall(
957         address target,
958         bytes memory data,
959         string memory errorMessage
960     ) internal view returns (bytes memory) {
961         (bool success, bytes memory returndata) = target.staticcall(data);
962         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
963     }
964 
965     /**
966      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
967      * but performing a delegate call.
968      *
969      * _Available since v3.4._
970      */
971     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
972         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
973     }
974 
975     /**
976      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
977      * but performing a delegate call.
978      *
979      * _Available since v3.4._
980      */
981     function functionDelegateCall(
982         address target,
983         bytes memory data,
984         string memory errorMessage
985     ) internal returns (bytes memory) {
986         (bool success, bytes memory returndata) = target.delegatecall(data);
987         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
988     }
989 
990     /**
991      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
992      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
993      *
994      * _Available since v4.8._
995      */
996     function verifyCallResultFromTarget(
997         address target,
998         bool success,
999         bytes memory returndata,
1000         string memory errorMessage
1001     ) internal view returns (bytes memory) {
1002         if (success) {
1003             if (returndata.length == 0) {
1004                 // only check isContract if the call was successful and the return data is empty
1005                 // otherwise we already know that it was a contract
1006                 require(isContract(target), "Address: call to non-contract");
1007             }
1008             return returndata;
1009         } else {
1010             _revert(returndata, errorMessage);
1011         }
1012     }
1013 
1014     /**
1015      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1016      * revert reason or using the provided one.
1017      *
1018      * _Available since v4.3._
1019      */
1020     function verifyCallResult(
1021         bool success,
1022         bytes memory returndata,
1023         string memory errorMessage
1024     ) internal pure returns (bytes memory) {
1025         if (success) {
1026             return returndata;
1027         } else {
1028             _revert(returndata, errorMessage);
1029         }
1030     }
1031 
1032     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1033         // Look for revert reason and bubble it up if present
1034         if (returndata.length > 0) {
1035             // The easiest way to bubble the revert reason is using memory via assembly
1036             /// @solidity memory-safe-assembly
1037             assembly {
1038                 let returndata_size := mload(returndata)
1039                 revert(add(32, returndata), returndata_size)
1040             }
1041         } else {
1042             revert(errorMessage);
1043         }
1044     }
1045 }
1046 
1047 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1048 
1049 
1050 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 /**
1055  * @title ERC721 token receiver interface
1056  * @dev Interface for any contract that wants to support safeTransfers
1057  * from ERC721 asset contracts.
1058  */
1059 interface IERC721Receiver {
1060     /**
1061      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1062      * by `operator` from `from`, this function is called.
1063      *
1064      * It must return its Solidity selector to confirm the token transfer.
1065      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1066      *
1067      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1068      */
1069     function onERC721Received(
1070         address operator,
1071         address from,
1072         uint256 tokenId,
1073         bytes calldata data
1074     ) external returns (bytes4);
1075 }
1076 
1077 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1078 
1079 
1080 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1081 
1082 pragma solidity ^0.8.0;
1083 
1084 /**
1085  * @dev Interface of the ERC165 standard, as defined in the
1086  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1087  *
1088  * Implementers can declare support of contract interfaces, which can then be
1089  * queried by others ({ERC165Checker}).
1090  *
1091  * For an implementation, see {ERC165}.
1092  */
1093 interface IERC165 {
1094     /**
1095      * @dev Returns true if this contract implements the interface defined by
1096      * `interfaceId`. See the corresponding
1097      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1098      * to learn more about how these ids are created.
1099      *
1100      * This function call must use less than 30 000 gas.
1101      */
1102     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1103 }
1104 
1105 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1106 
1107 
1108 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1109 
1110 pragma solidity ^0.8.0;
1111 
1112 
1113 /**
1114  * @dev Interface for the NFT Royalty Standard.
1115  *
1116  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1117  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1118  *
1119  * _Available since v4.5._
1120  */
1121 interface IERC2981 is IERC165 {
1122     /**
1123      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1124      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1125      */
1126     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1127         external
1128         view
1129         returns (address receiver, uint256 royaltyAmount);
1130 }
1131 
1132 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1133 
1134 
1135 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 /**
1141  * @dev Implementation of the {IERC165} interface.
1142  *
1143  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1144  * for the additional interface id that will be supported. For example:
1145  *
1146  * ```solidity
1147  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1148  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1149  * }
1150  * ```
1151  *
1152  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1153  */
1154 abstract contract ERC165 is IERC165 {
1155     /**
1156      * @dev See {IERC165-supportsInterface}.
1157      */
1158     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1159         return interfaceId == type(IERC165).interfaceId;
1160     }
1161 }
1162 
1163 // File: resolvers/BaseResolver.sol
1164 
1165 
1166 pragma solidity ^0.8.9;
1167 
1168 
1169 abstract contract BaseResolver is ERC165 {
1170     modifier authorised(bytes32 node) {
1171         require(_isAuthorised(node));
1172         _;
1173     }
1174 
1175     function _isAuthorised(bytes32 node) internal view virtual returns (bool);
1176 
1177     function _bytesToAddress(bytes memory b)
1178         internal
1179         pure
1180         returns (address payable a)
1181     {
1182         require(b.length == 20);
1183         assembly {
1184             a := div(mload(add(b, 32)), exp(256, 12))
1185         }
1186     }
1187 
1188     function _addressToBytes(address a) internal pure returns (bytes memory b) {
1189         b = new bytes(20);
1190         assembly {
1191             mstore(add(b, 32), mul(a, exp(256, 12)))
1192         }
1193     }
1194 }
1195 
1196 // File: resolvers/AddrResolver.sol
1197 
1198 
1199 pragma solidity ^0.8.9;
1200 
1201 
1202 abstract contract AddrResolver is BaseResolver {
1203     bytes4 private constant ADDR_INTERFACE_ID = 0x3b3b57de;
1204     bytes4 private constant ADDRESS_INTERFACE_ID = 0xf1cb7e06;
1205     uint private constant COIN_TYPE_ETH = 60;
1206 
1207     event AddrChanged(bytes32 indexed node, address a);
1208     event AddressChanged(bytes32 indexed node, uint coinType, bytes newAddress);
1209 
1210     mapping(bytes32 => mapping(uint => bytes)) _addresses;
1211 
1212     /**
1213      * Sets the address associated with an KEY3 node.
1214      * May only be called by the owner of that node in the KEY3 registry.
1215      * @param node The node to update.
1216      * @param a The address to set.
1217      */
1218     function setAddr(bytes32 node, address a) external authorised(node) {
1219         setAddr(node, COIN_TYPE_ETH, _addressToBytes(a));
1220     }
1221 
1222     /**
1223      * Returns the address associated with an KEY3 node.
1224      * @param node The KEY3 node to query.
1225      * @return The associated address.
1226      */
1227     function addr(bytes32 node) public view returns (address payable) {
1228         bytes memory a = addr(node, COIN_TYPE_ETH);
1229         if (a.length == 0) {
1230             return payable(address(0));
1231         }
1232         return _bytesToAddress(a);
1233     }
1234 
1235     function setAddr(
1236         bytes32 node,
1237         uint coinType,
1238         bytes memory a
1239     ) public authorised(node) {
1240         emit AddressChanged(node, coinType, a);
1241         if (coinType == COIN_TYPE_ETH) {
1242             emit AddrChanged(node, _bytesToAddress(a));
1243         }
1244         _addresses[node][coinType] = a;
1245     }
1246 
1247     function addr(bytes32 node, uint coinType)
1248         public
1249         view
1250         returns (bytes memory)
1251     {
1252         return _addresses[node][coinType];
1253     }
1254 
1255     function supportsInterface(bytes4 interfaceId)
1256         public
1257         view
1258         virtual
1259         override
1260         returns (bool)
1261     {
1262         return
1263             interfaceId == ADDR_INTERFACE_ID ||
1264             interfaceId == ADDRESS_INTERFACE_ID ||
1265             super.supportsInterface(interfaceId);
1266     }
1267 }
1268 
1269 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1270 
1271 
1272 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1273 
1274 pragma solidity ^0.8.0;
1275 
1276 
1277 
1278 /**
1279  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1280  *
1281  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1282  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1283  *
1284  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1285  * fee is specified in basis points by default.
1286  *
1287  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1288  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1289  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1290  *
1291  * _Available since v4.5._
1292  */
1293 abstract contract ERC2981 is IERC2981, ERC165 {
1294     struct RoyaltyInfo {
1295         address receiver;
1296         uint96 royaltyFraction;
1297     }
1298 
1299     RoyaltyInfo private _defaultRoyaltyInfo;
1300     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1301 
1302     /**
1303      * @dev See {IERC165-supportsInterface}.
1304      */
1305     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1306         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1307     }
1308 
1309     /**
1310      * @inheritdoc IERC2981
1311      */
1312     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1313         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1314 
1315         if (royalty.receiver == address(0)) {
1316             royalty = _defaultRoyaltyInfo;
1317         }
1318 
1319         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1320 
1321         return (royalty.receiver, royaltyAmount);
1322     }
1323 
1324     /**
1325      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1326      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1327      * override.
1328      */
1329     function _feeDenominator() internal pure virtual returns (uint96) {
1330         return 10000;
1331     }
1332 
1333     /**
1334      * @dev Sets the royalty information that all ids in this contract will default to.
1335      *
1336      * Requirements:
1337      *
1338      * - `receiver` cannot be the zero address.
1339      * - `feeNumerator` cannot be greater than the fee denominator.
1340      */
1341     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1342         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1343         require(receiver != address(0), "ERC2981: invalid receiver");
1344 
1345         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1346     }
1347 
1348     /**
1349      * @dev Removes default royalty information.
1350      */
1351     function _deleteDefaultRoyalty() internal virtual {
1352         delete _defaultRoyaltyInfo;
1353     }
1354 
1355     /**
1356      * @dev Sets the royalty information for a specific token id, overriding the global default.
1357      *
1358      * Requirements:
1359      *
1360      * - `receiver` cannot be the zero address.
1361      * - `feeNumerator` cannot be greater than the fee denominator.
1362      */
1363     function _setTokenRoyalty(
1364         uint256 tokenId,
1365         address receiver,
1366         uint96 feeNumerator
1367     ) internal virtual {
1368         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1369         require(receiver != address(0), "ERC2981: Invalid parameters");
1370 
1371         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1372     }
1373 
1374     /**
1375      * @dev Resets royalty information for the token id back to the global default.
1376      */
1377     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1378         delete _tokenRoyaltyInfo[tokenId];
1379     }
1380 }
1381 
1382 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1383 
1384 
1385 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 
1390 /**
1391  * @dev Required interface of an ERC721 compliant contract.
1392  */
1393 interface IERC721 is IERC165 {
1394     /**
1395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1396      */
1397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1398 
1399     /**
1400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1401      */
1402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1403 
1404     /**
1405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1406      */
1407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1408 
1409     /**
1410      * @dev Returns the number of tokens in ``owner``'s account.
1411      */
1412     function balanceOf(address owner) external view returns (uint256 balance);
1413 
1414     /**
1415      * @dev Returns the owner of the `tokenId` token.
1416      *
1417      * Requirements:
1418      *
1419      * - `tokenId` must exist.
1420      */
1421     function ownerOf(uint256 tokenId) external view returns (address owner);
1422 
1423     /**
1424      * @dev Safely transfers `tokenId` token from `from` to `to`.
1425      *
1426      * Requirements:
1427      *
1428      * - `from` cannot be the zero address.
1429      * - `to` cannot be the zero address.
1430      * - `tokenId` token must exist and be owned by `from`.
1431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function safeTransferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId,
1440         bytes calldata data
1441     ) external;
1442 
1443     /**
1444      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1445      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1446      *
1447      * Requirements:
1448      *
1449      * - `from` cannot be the zero address.
1450      * - `to` cannot be the zero address.
1451      * - `tokenId` token must exist and be owned by `from`.
1452      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1454      *
1455      * Emits a {Transfer} event.
1456      */
1457     function safeTransferFrom(
1458         address from,
1459         address to,
1460         uint256 tokenId
1461     ) external;
1462 
1463     /**
1464      * @dev Transfers `tokenId` token from `from` to `to`.
1465      *
1466      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1467      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1468      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1469      *
1470      * Requirements:
1471      *
1472      * - `from` cannot be the zero address.
1473      * - `to` cannot be the zero address.
1474      * - `tokenId` token must be owned by `from`.
1475      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function transferFrom(
1480         address from,
1481         address to,
1482         uint256 tokenId
1483     ) external;
1484 
1485     /**
1486      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1487      * The approval is cleared when the token is transferred.
1488      *
1489      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1490      *
1491      * Requirements:
1492      *
1493      * - The caller must own the token or be an approved operator.
1494      * - `tokenId` must exist.
1495      *
1496      * Emits an {Approval} event.
1497      */
1498     function approve(address to, uint256 tokenId) external;
1499 
1500     /**
1501      * @dev Approve or remove `operator` as an operator for the caller.
1502      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1503      *
1504      * Requirements:
1505      *
1506      * - The `operator` cannot be the caller.
1507      *
1508      * Emits an {ApprovalForAll} event.
1509      */
1510     function setApprovalForAll(address operator, bool _approved) external;
1511 
1512     /**
1513      * @dev Returns the account approved for `tokenId` token.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      */
1519     function getApproved(uint256 tokenId) external view returns (address operator);
1520 
1521     /**
1522      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1523      *
1524      * See {setApprovalForAll}
1525      */
1526     function isApprovedForAll(address owner, address operator) external view returns (bool);
1527 }
1528 
1529 // File: IKEY3FreeRegistrar.sol
1530 
1531 
1532 pragma solidity ^0.8.9;
1533 
1534 
1535 
1536 interface IKEY3FreeRegistrar is IERC721 {
1537     event NameRegistered(uint256 indexed id, address indexed owner);
1538 
1539     function baseNode() external view returns (bytes32);
1540 
1541     function key3() external view returns (IKEY3);
1542 
1543     // Authorizes a controller, who can register and renew domains.
1544     function addController(address controller) external;
1545 
1546     // Revoke controller permission for an address.
1547     function removeController(address controller) external;
1548 
1549     // Set the resolver for the TLD this registrar manages.
1550     function setResolver(address resolver) external;
1551 
1552     // Returns true iff the specified name is available for registration.
1553     function available(uint256 id) external view returns (bool);
1554 
1555     /**
1556      * @dev Register a name.
1557      */
1558     function register(uint256 id, address owner) external;
1559 
1560     /**
1561      * @dev Reclaim ownership of a name in KEY3, if you own it in the registrar.`
1562      */
1563     function reclaim(uint256 id, address owner) external;
1564 }
1565 
1566 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1567 
1568 
1569 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 
1574 /**
1575  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1576  * @dev See https://eips.ethereum.org/EIPS/eip-721
1577  */
1578 interface IERC721Metadata is IERC721 {
1579     /**
1580      * @dev Returns the token collection name.
1581      */
1582     function name() external view returns (string memory);
1583 
1584     /**
1585      * @dev Returns the token collection symbol.
1586      */
1587     function symbol() external view returns (string memory);
1588 
1589     /**
1590      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1591      */
1592     function tokenURI(uint256 tokenId) external view returns (string memory);
1593 }
1594 
1595 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1596 
1597 
1598 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1599 
1600 pragma solidity ^0.8.0;
1601 
1602 
1603 
1604 
1605 
1606 
1607 
1608 
1609 /**
1610  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1611  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1612  * {ERC721Enumerable}.
1613  */
1614 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1615     using Address for address;
1616     using Strings for uint256;
1617 
1618     // Token name
1619     string private _name;
1620 
1621     // Token symbol
1622     string private _symbol;
1623 
1624     // Mapping from token ID to owner address
1625     mapping(uint256 => address) private _owners;
1626 
1627     // Mapping owner address to token count
1628     mapping(address => uint256) private _balances;
1629 
1630     // Mapping from token ID to approved address
1631     mapping(uint256 => address) private _tokenApprovals;
1632 
1633     // Mapping from owner to operator approvals
1634     mapping(address => mapping(address => bool)) private _operatorApprovals;
1635 
1636     /**
1637      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1638      */
1639     constructor(string memory name_, string memory symbol_) {
1640         _name = name_;
1641         _symbol = symbol_;
1642     }
1643 
1644     /**
1645      * @dev See {IERC165-supportsInterface}.
1646      */
1647     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1648         return
1649             interfaceId == type(IERC721).interfaceId ||
1650             interfaceId == type(IERC721Metadata).interfaceId ||
1651             super.supportsInterface(interfaceId);
1652     }
1653 
1654     /**
1655      * @dev See {IERC721-balanceOf}.
1656      */
1657     function balanceOf(address owner) public view virtual override returns (uint256) {
1658         require(owner != address(0), "ERC721: address zero is not a valid owner");
1659         return _balances[owner];
1660     }
1661 
1662     /**
1663      * @dev See {IERC721-ownerOf}.
1664      */
1665     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1666         address owner = _ownerOf(tokenId);
1667         require(owner != address(0), "ERC721: invalid token ID");
1668         return owner;
1669     }
1670 
1671     /**
1672      * @dev See {IERC721Metadata-name}.
1673      */
1674     function name() public view virtual override returns (string memory) {
1675         return _name;
1676     }
1677 
1678     /**
1679      * @dev See {IERC721Metadata-symbol}.
1680      */
1681     function symbol() public view virtual override returns (string memory) {
1682         return _symbol;
1683     }
1684 
1685     /**
1686      * @dev See {IERC721Metadata-tokenURI}.
1687      */
1688     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1689         _requireMinted(tokenId);
1690 
1691         string memory baseURI = _baseURI();
1692         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1693     }
1694 
1695     /**
1696      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1697      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1698      * by default, can be overridden in child contracts.
1699      */
1700     function _baseURI() internal view virtual returns (string memory) {
1701         return "";
1702     }
1703 
1704     /**
1705      * @dev See {IERC721-approve}.
1706      */
1707     function approve(address to, uint256 tokenId) public virtual override {
1708         address owner = ERC721.ownerOf(tokenId);
1709         require(to != owner, "ERC721: approval to current owner");
1710 
1711         require(
1712             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1713             "ERC721: approve caller is not token owner or approved for all"
1714         );
1715 
1716         _approve(to, tokenId);
1717     }
1718 
1719     /**
1720      * @dev See {IERC721-getApproved}.
1721      */
1722     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1723         _requireMinted(tokenId);
1724 
1725         return _tokenApprovals[tokenId];
1726     }
1727 
1728     /**
1729      * @dev See {IERC721-setApprovalForAll}.
1730      */
1731     function setApprovalForAll(address operator, bool approved) public virtual override {
1732         _setApprovalForAll(_msgSender(), operator, approved);
1733     }
1734 
1735     /**
1736      * @dev See {IERC721-isApprovedForAll}.
1737      */
1738     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1739         return _operatorApprovals[owner][operator];
1740     }
1741 
1742     /**
1743      * @dev See {IERC721-transferFrom}.
1744      */
1745     function transferFrom(
1746         address from,
1747         address to,
1748         uint256 tokenId
1749     ) public virtual override {
1750         //solhint-disable-next-line max-line-length
1751         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1752 
1753         _transfer(from, to, tokenId);
1754     }
1755 
1756     /**
1757      * @dev See {IERC721-safeTransferFrom}.
1758      */
1759     function safeTransferFrom(
1760         address from,
1761         address to,
1762         uint256 tokenId
1763     ) public virtual override {
1764         safeTransferFrom(from, to, tokenId, "");
1765     }
1766 
1767     /**
1768      * @dev See {IERC721-safeTransferFrom}.
1769      */
1770     function safeTransferFrom(
1771         address from,
1772         address to,
1773         uint256 tokenId,
1774         bytes memory data
1775     ) public virtual override {
1776         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1777         _safeTransfer(from, to, tokenId, data);
1778     }
1779 
1780     /**
1781      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1782      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1783      *
1784      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1785      *
1786      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1787      * implement alternative mechanisms to perform token transfer, such as signature-based.
1788      *
1789      * Requirements:
1790      *
1791      * - `from` cannot be the zero address.
1792      * - `to` cannot be the zero address.
1793      * - `tokenId` token must exist and be owned by `from`.
1794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1795      *
1796      * Emits a {Transfer} event.
1797      */
1798     function _safeTransfer(
1799         address from,
1800         address to,
1801         uint256 tokenId,
1802         bytes memory data
1803     ) internal virtual {
1804         _transfer(from, to, tokenId);
1805         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1806     }
1807 
1808     /**
1809      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1810      */
1811     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1812         return _owners[tokenId];
1813     }
1814 
1815     /**
1816      * @dev Returns whether `tokenId` exists.
1817      *
1818      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1819      *
1820      * Tokens start existing when they are minted (`_mint`),
1821      * and stop existing when they are burned (`_burn`).
1822      */
1823     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1824         return _ownerOf(tokenId) != address(0);
1825     }
1826 
1827     /**
1828      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1829      *
1830      * Requirements:
1831      *
1832      * - `tokenId` must exist.
1833      */
1834     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1835         address owner = ERC721.ownerOf(tokenId);
1836         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1837     }
1838 
1839     /**
1840      * @dev Safely mints `tokenId` and transfers it to `to`.
1841      *
1842      * Requirements:
1843      *
1844      * - `tokenId` must not exist.
1845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1846      *
1847      * Emits a {Transfer} event.
1848      */
1849     function _safeMint(address to, uint256 tokenId) internal virtual {
1850         _safeMint(to, tokenId, "");
1851     }
1852 
1853     /**
1854      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1855      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1856      */
1857     function _safeMint(
1858         address to,
1859         uint256 tokenId,
1860         bytes memory data
1861     ) internal virtual {
1862         _mint(to, tokenId);
1863         require(
1864             _checkOnERC721Received(address(0), to, tokenId, data),
1865             "ERC721: transfer to non ERC721Receiver implementer"
1866         );
1867     }
1868 
1869     /**
1870      * @dev Mints `tokenId` and transfers it to `to`.
1871      *
1872      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1873      *
1874      * Requirements:
1875      *
1876      * - `tokenId` must not exist.
1877      * - `to` cannot be the zero address.
1878      *
1879      * Emits a {Transfer} event.
1880      */
1881     function _mint(address to, uint256 tokenId) internal virtual {
1882         require(to != address(0), "ERC721: mint to the zero address");
1883         require(!_exists(tokenId), "ERC721: token already minted");
1884 
1885         _beforeTokenTransfer(address(0), to, tokenId, 1);
1886 
1887         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1888         require(!_exists(tokenId), "ERC721: token already minted");
1889 
1890         unchecked {
1891             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1892             // Given that tokens are minted one by one, it is impossible in practice that
1893             // this ever happens. Might change if we allow batch minting.
1894             // The ERC fails to describe this case.
1895             _balances[to] += 1;
1896         }
1897 
1898         _owners[tokenId] = to;
1899 
1900         emit Transfer(address(0), to, tokenId);
1901 
1902         _afterTokenTransfer(address(0), to, tokenId, 1);
1903     }
1904 
1905     /**
1906      * @dev Destroys `tokenId`.
1907      * The approval is cleared when the token is burned.
1908      * This is an internal function that does not check if the sender is authorized to operate on the token.
1909      *
1910      * Requirements:
1911      *
1912      * - `tokenId` must exist.
1913      *
1914      * Emits a {Transfer} event.
1915      */
1916     function _burn(uint256 tokenId) internal virtual {
1917         address owner = ERC721.ownerOf(tokenId);
1918 
1919         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1920 
1921         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1922         owner = ERC721.ownerOf(tokenId);
1923 
1924         // Clear approvals
1925         delete _tokenApprovals[tokenId];
1926 
1927         unchecked {
1928             // Cannot overflow, as that would require more tokens to be burned/transferred
1929             // out than the owner initially received through minting and transferring in.
1930             _balances[owner] -= 1;
1931         }
1932         delete _owners[tokenId];
1933 
1934         emit Transfer(owner, address(0), tokenId);
1935 
1936         _afterTokenTransfer(owner, address(0), tokenId, 1);
1937     }
1938 
1939     /**
1940      * @dev Transfers `tokenId` from `from` to `to`.
1941      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1942      *
1943      * Requirements:
1944      *
1945      * - `to` cannot be the zero address.
1946      * - `tokenId` token must be owned by `from`.
1947      *
1948      * Emits a {Transfer} event.
1949      */
1950     function _transfer(
1951         address from,
1952         address to,
1953         uint256 tokenId
1954     ) internal virtual {
1955         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1956         require(to != address(0), "ERC721: transfer to the zero address");
1957 
1958         _beforeTokenTransfer(from, to, tokenId, 1);
1959 
1960         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1961         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1962 
1963         // Clear approvals from the previous owner
1964         delete _tokenApprovals[tokenId];
1965 
1966         unchecked {
1967             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1968             // `from`'s balance is the number of token held, which is at least one before the current
1969             // transfer.
1970             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1971             // all 2**256 token ids to be minted, which in practice is impossible.
1972             _balances[from] -= 1;
1973             _balances[to] += 1;
1974         }
1975         _owners[tokenId] = to;
1976 
1977         emit Transfer(from, to, tokenId);
1978 
1979         _afterTokenTransfer(from, to, tokenId, 1);
1980     }
1981 
1982     /**
1983      * @dev Approve `to` to operate on `tokenId`
1984      *
1985      * Emits an {Approval} event.
1986      */
1987     function _approve(address to, uint256 tokenId) internal virtual {
1988         _tokenApprovals[tokenId] = to;
1989         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1990     }
1991 
1992     /**
1993      * @dev Approve `operator` to operate on all of `owner` tokens
1994      *
1995      * Emits an {ApprovalForAll} event.
1996      */
1997     function _setApprovalForAll(
1998         address owner,
1999         address operator,
2000         bool approved
2001     ) internal virtual {
2002         require(owner != operator, "ERC721: approve to caller");
2003         _operatorApprovals[owner][operator] = approved;
2004         emit ApprovalForAll(owner, operator, approved);
2005     }
2006 
2007     /**
2008      * @dev Reverts if the `tokenId` has not been minted yet.
2009      */
2010     function _requireMinted(uint256 tokenId) internal view virtual {
2011         require(_exists(tokenId), "ERC721: invalid token ID");
2012     }
2013 
2014     /**
2015      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2016      * The call is not executed if the target address is not a contract.
2017      *
2018      * @param from address representing the previous owner of the given token ID
2019      * @param to target address that will receive the tokens
2020      * @param tokenId uint256 ID of the token to be transferred
2021      * @param data bytes optional data to send along with the call
2022      * @return bool whether the call correctly returned the expected magic value
2023      */
2024     function _checkOnERC721Received(
2025         address from,
2026         address to,
2027         uint256 tokenId,
2028         bytes memory data
2029     ) private returns (bool) {
2030         if (to.isContract()) {
2031             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2032                 return retval == IERC721Receiver.onERC721Received.selector;
2033             } catch (bytes memory reason) {
2034                 if (reason.length == 0) {
2035                     revert("ERC721: transfer to non ERC721Receiver implementer");
2036                 } else {
2037                     /// @solidity memory-safe-assembly
2038                     assembly {
2039                         revert(add(32, reason), mload(reason))
2040                     }
2041                 }
2042             }
2043         } else {
2044             return true;
2045         }
2046     }
2047 
2048     /**
2049      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2050      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2051      *
2052      * Calling conditions:
2053      *
2054      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2055      * - When `from` is zero, the tokens will be minted for `to`.
2056      * - When `to` is zero, ``from``'s tokens will be burned.
2057      * - `from` and `to` are never both zero.
2058      * - `batchSize` is non-zero.
2059      *
2060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2061      */
2062     function _beforeTokenTransfer(
2063         address from,
2064         address to,
2065         uint256, /* firstTokenId */
2066         uint256 batchSize
2067     ) internal virtual {
2068         if (batchSize > 1) {
2069             if (from != address(0)) {
2070                 _balances[from] -= batchSize;
2071             }
2072             if (to != address(0)) {
2073                 _balances[to] += batchSize;
2074             }
2075         }
2076     }
2077 
2078     /**
2079      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2080      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2081      *
2082      * Calling conditions:
2083      *
2084      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2085      * - When `from` is zero, the tokens were minted for `to`.
2086      * - When `to` is zero, ``from``'s tokens were burned.
2087      * - `from` and `to` are never both zero.
2088      * - `batchSize` is non-zero.
2089      *
2090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2091      */
2092     function _afterTokenTransfer(
2093         address from,
2094         address to,
2095         uint256 firstTokenId,
2096         uint256 batchSize
2097     ) internal virtual {}
2098 }
2099 
2100 // File: KEY3FreeRegistrar.sol
2101 
2102 
2103 pragma solidity ^0.8.9;
2104 
2105 
2106 
2107 
2108 
2109 
2110 
2111 
2112 
2113 contract KEY3FreeRegistrar is
2114     ERC2981,
2115     ERC721,
2116     IKEY3FreeRegistrar,
2117     DefaultOperatorFilterer,
2118     Ownable,
2119     Controllable
2120 {
2121     string private _baseUri;
2122 
2123     event SetDefaultRoyalty(address indexed receiver, uint96 feeNumerator);
2124     event SetTokenRoyalty(
2125         uint256 indexed tokenId,
2126         address indexed receiver,
2127         uint96 feeNumerator
2128     );
2129 
2130     // The KEY3 registry
2131     IKEY3 public key3;
2132     // The namehash of the TLD this registrar owns (eg, .did)
2133     bytes32 public baseNode;
2134 
2135     constructor(
2136         string memory name_,
2137         string memory symbol_,
2138         IKEY3 key3_,
2139         bytes32 baseNode_
2140     ) ERC721(name_, symbol_) {
2141         key3 = key3_;
2142         baseNode = baseNode_;
2143     }
2144 
2145     modifier live() {
2146         require(key3.owner(baseNode) == address(this));
2147         _;
2148     }
2149 
2150     function _baseURI() internal view override returns (string memory) {
2151         return _baseUri;
2152     }
2153 
2154     function setBaseURI(string memory baseURI_) external onlyOwner {
2155         _baseUri = baseURI_;
2156     }
2157 
2158     function addController(address controller_) external onlyOwner {
2159         _addController(controller_);
2160     }
2161 
2162     function removeController(address controller_) external onlyOwner {
2163         _removeController(controller_);
2164     }
2165 
2166     function setDefaultRoyalty(address receiver_, uint96 feeNumerator_)
2167         public
2168         onlyOwner
2169     {
2170         _setDefaultRoyalty(receiver_, feeNumerator_);
2171         emit SetDefaultRoyalty(receiver_, feeNumerator_);
2172     }
2173 
2174     function setTokenRoyalty(
2175         uint256 tokenId_,
2176         address receiver_,
2177         uint96 feeNumerator_
2178     ) public onlyOwner {
2179         _setTokenRoyalty(tokenId_, receiver_, feeNumerator_);
2180         emit SetTokenRoyalty(tokenId_, receiver_, feeNumerator_);
2181     }
2182 
2183     // Set the resolver for the TLD this registrar manages.
2184     function setResolver(address resolver_) external onlyOwner {
2185         key3.setResolver(baseNode, resolver_);
2186     }
2187 
2188     // Returns true iff the specified name is available for registration.
2189     function available(uint256 id_) public view returns (bool) {
2190         // Not available if it's registered here
2191         return !_exists(id_);
2192     }
2193 
2194     /**
2195      * @dev Register a name.
2196      * @param id_ The token ID (keccak256 of the label).
2197      * @param owner_ The address that should own the registration.
2198      */
2199     function register(uint256 id_, address owner_) external {
2200         _register(id_, owner_, true);
2201     }
2202 
2203     /**
2204      * @dev Register a name, without modifying the registry.
2205      * @param id_ The token ID (keccak256 of the label).
2206      * @param owner_ The address that should own the registration.
2207      */
2208     function registerOnly(uint256 id_, address owner_) external {
2209         _register(id_, owner_, false);
2210     }
2211 
2212     function _register(
2213         uint256 id_,
2214         address owner_,
2215         bool updateRegistry_
2216     ) internal live onlyController {
2217         require(available(id_), "this did is not available");
2218 
2219         _mint(owner_, id_);
2220         if (updateRegistry_) {
2221             key3.setSubnodeOwner(baseNode, bytes32(id_), owner_);
2222         }
2223 
2224         emit NameRegistered(id_, owner_);
2225     }
2226 
2227     /**
2228      * @dev Reclaim ownership of a name in KEY3, if you own it in the registrar.
2229      */
2230     function reclaim(uint256 id_, address owner_) external {
2231         _reclaim(id_, owner_);
2232     }
2233 
2234     function _reclaim(uint256 id_, address owner_) internal live {
2235         require(_isApprovedOrOwner(msg.sender, id_));
2236         key3.setSubnodeOwner(baseNode, bytes32(id_), owner_);
2237     }
2238 
2239     function transferFrom(
2240         address from,
2241         address to,
2242         uint256 tokenId
2243     ) public override(IERC721, ERC721) onlyAllowedOperator(from) {
2244         super.transferFrom(from, to, tokenId);
2245     }
2246 
2247     function safeTransferFrom(
2248         address from,
2249         address to,
2250         uint256 tokenId
2251     ) public override(IERC721, ERC721) onlyAllowedOperator(from) {
2252         super.safeTransferFrom(from, to, tokenId);
2253     }
2254 
2255     function safeTransferFrom(
2256         address from,
2257         address to,
2258         uint256 tokenId,
2259         bytes memory data
2260     ) public override(IERC721, ERC721) onlyAllowedOperator(from) {
2261         super.safeTransferFrom(from, to, tokenId, data);
2262     }
2263 
2264     function _beforeTokenTransfer(
2265         address from_,
2266         address to_,
2267         uint256 tokenId_,
2268         uint256 batchSize
2269     ) internal override {
2270         super._beforeTokenTransfer(from_, to_, tokenId_, batchSize);
2271         if (from_ != address(0)) {
2272             _reclaim(tokenId_, to_);
2273         }
2274     }
2275 
2276     function supportsInterface(bytes4 interfaceId)
2277         public
2278         view
2279         override(ERC2981, ERC721, IERC165)
2280         returns (bool)
2281     {
2282         return
2283             interfaceId == type(ERC2981).interfaceId ||
2284             super.supportsInterface(interfaceId);
2285     }
2286 }