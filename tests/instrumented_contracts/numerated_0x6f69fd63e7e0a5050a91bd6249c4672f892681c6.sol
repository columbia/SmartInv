1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0;
3 
4 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
5 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
6 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
7 abstract contract ERC721 {
8     /*///////////////////////////////////////////////////////////////
9                                  EVENTS
10     //////////////////////////////////////////////////////////////*/
11 
12     event Transfer(address indexed from, address indexed to, uint256 indexed id);
13 
14     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
15 
16     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
17 
18     /*///////////////////////////////////////////////////////////////
19                           METADATA STORAGE/LOGIC
20     //////////////////////////////////////////////////////////////*/
21 
22     string public name;
23 
24     string public symbol;
25 
26     function tokenURI(uint256 id) public view virtual returns (string memory);
27 
28     /*///////////////////////////////////////////////////////////////
29                             ERC721 STORAGE                        
30     //////////////////////////////////////////////////////////////*/
31 
32     mapping(address => uint256) public balanceOf;
33 
34     mapping(uint256 => address) public ownerOf;
35 
36     mapping(uint256 => address) public getApproved;
37 
38     mapping(address => mapping(address => bool)) public isApprovedForAll;
39 
40     /*///////////////////////////////////////////////////////////////
41                               CONSTRUCTOR
42     //////////////////////////////////////////////////////////////*/
43 
44     constructor(string memory _name, string memory _symbol) {
45         name = _name;
46         symbol = _symbol;
47     }
48 
49     /*///////////////////////////////////////////////////////////////
50                               ERC721 LOGIC
51     //////////////////////////////////////////////////////////////*/
52 
53     function approve(address spender, uint256 id) public virtual {
54         address owner = ownerOf[id];
55 
56         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
57 
58         getApproved[id] = spender;
59 
60         emit Approval(owner, spender, id);
61     }
62 
63     function setApprovalForAll(address operator, bool approved) public virtual {
64         isApprovedForAll[msg.sender][operator] = approved;
65 
66         emit ApprovalForAll(msg.sender, operator, approved);
67     }
68 
69     function transferFrom(
70         address from,
71         address to,
72         uint256 id
73     ) public virtual {
74         require(from == ownerOf[id], "WRONG_FROM");
75 
76         require(to != address(0), "INVALID_RECIPIENT");
77 
78         require(
79             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
80             "NOT_AUTHORIZED"
81         );
82 
83         // Underflow of the sender's balance is impossible because we check for
84         // ownership above and the recipient's balance can't realistically overflow.
85         unchecked {
86             balanceOf[from]--;
87 
88             balanceOf[to]++;
89         }
90 
91         ownerOf[id] = to;
92 
93         delete getApproved[id];
94 
95         emit Transfer(from, to, id);
96     }
97 
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 id
102     ) public virtual {
103         transferFrom(from, to, id);
104 
105         require(
106             to.code.length == 0 ||
107                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
108                 ERC721TokenReceiver.onERC721Received.selector,
109             "UNSAFE_RECIPIENT"
110         );
111     }
112 
113     function safeTransferFrom(
114         address from,
115         address to,
116         uint256 id,
117         bytes memory data
118     ) public virtual {
119         transferFrom(from, to, id);
120 
121         require(
122             to.code.length == 0 ||
123                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
124                 ERC721TokenReceiver.onERC721Received.selector,
125             "UNSAFE_RECIPIENT"
126         );
127     }
128 
129     /*///////////////////////////////////////////////////////////////
130                               ERC165 LOGIC
131     //////////////////////////////////////////////////////////////*/
132 
133     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
134         return
135             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
136             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
137             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
138     }
139 
140     /*///////////////////////////////////////////////////////////////
141                        INTERNAL MINT/BURN LOGIC
142     //////////////////////////////////////////////////////////////*/
143 
144     function _mint(address to, uint256 id) internal virtual {
145         require(to != address(0), "INVALID_RECIPIENT");
146 
147         require(ownerOf[id] == address(0), "ALREADY_MINTED");
148 
149         // Counter overflow is incredibly unrealistic.
150         unchecked {
151             balanceOf[to]++;
152         }
153 
154         ownerOf[id] = to;
155 
156         emit Transfer(address(0), to, id);
157     }
158 
159     function _burn(uint256 id) internal virtual {
160         address owner = ownerOf[id];
161 
162         require(ownerOf[id] != address(0), "NOT_MINTED");
163 
164         // Ownership check above ensures no underflow.
165         unchecked {
166             balanceOf[owner]--;
167         }
168 
169         delete ownerOf[id];
170 
171         delete getApproved[id];
172 
173         emit Transfer(owner, address(0), id);
174     }
175 
176     /*///////////////////////////////////////////////////////////////
177                        INTERNAL SAFE MINT LOGIC
178     //////////////////////////////////////////////////////////////*/
179 
180     function _safeMint(address to, uint256 id) internal virtual {
181         _mint(to, id);
182 
183         require(
184             to.code.length == 0 ||
185                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
186                 ERC721TokenReceiver.onERC721Received.selector,
187             "UNSAFE_RECIPIENT"
188         );
189     }
190 
191     function _safeMint(
192         address to,
193         uint256 id,
194         bytes memory data
195     ) internal virtual {
196         _mint(to, id);
197 
198         require(
199             to.code.length == 0 ||
200                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
201                 ERC721TokenReceiver.onERC721Received.selector,
202             "UNSAFE_RECIPIENT"
203         );
204     }
205 }
206 
207 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
208 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
209 interface ERC721TokenReceiver {
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 id,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217 
218 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
219 
220 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
221 
222 /**
223  * @dev Standard math utilities missing in the Solidity language.
224  */
225 library Math {
226     enum Rounding {
227         Down, // Toward negative infinity
228         Up, // Toward infinity
229         Zero // Toward zero
230     }
231 
232     /**
233      * @dev Returns the largest of two numbers.
234      */
235     function max(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a > b ? a : b;
237     }
238 
239     /**
240      * @dev Returns the smallest of two numbers.
241      */
242     function min(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a < b ? a : b;
244     }
245 
246     /**
247      * @dev Returns the average of two numbers. The result is rounded towards
248      * zero.
249      */
250     function average(uint256 a, uint256 b) internal pure returns (uint256) {
251         // (a + b) / 2 can overflow.
252         return (a & b) + (a ^ b) / 2;
253     }
254 
255     /**
256      * @dev Returns the ceiling of the division of two numbers.
257      *
258      * This differs from standard division with `/` in that it rounds up instead
259      * of rounding down.
260      */
261     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
262         // (a + b - 1) / b can overflow on addition, so we distribute.
263         return a == 0 ? 0 : (a - 1) / b + 1;
264     }
265 
266     /**
267      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
268      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
269      * with further edits by Uniswap Labs also under MIT license.
270      */
271     function mulDiv(
272         uint256 x,
273         uint256 y,
274         uint256 denominator
275     ) internal pure returns (uint256 result) {
276         unchecked {
277             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
278             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
279             // variables such that product = prod1 * 2^256 + prod0.
280             uint256 prod0; // Least significant 256 bits of the product
281             uint256 prod1; // Most significant 256 bits of the product
282             assembly {
283                 let mm := mulmod(x, y, not(0))
284                 prod0 := mul(x, y)
285                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
286             }
287 
288             // Handle non-overflow cases, 256 by 256 division.
289             if (prod1 == 0) {
290                 return prod0 / denominator;
291             }
292 
293             // Make sure the result is less than 2^256. Also prevents denominator == 0.
294             require(denominator > prod1);
295 
296             ///////////////////////////////////////////////
297             // 512 by 256 division.
298             ///////////////////////////////////////////////
299 
300             // Make division exact by subtracting the remainder from [prod1 prod0].
301             uint256 remainder;
302             assembly {
303                 // Compute remainder using mulmod.
304                 remainder := mulmod(x, y, denominator)
305 
306                 // Subtract 256 bit number from 512 bit number.
307                 prod1 := sub(prod1, gt(remainder, prod0))
308                 prod0 := sub(prod0, remainder)
309             }
310 
311             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
312             // See https://cs.stackexchange.com/q/138556/92363.
313 
314             // Does not overflow because the denominator cannot be zero at this stage in the function.
315             uint256 twos = denominator & (~denominator + 1);
316             assembly {
317                 // Divide denominator by twos.
318                 denominator := div(denominator, twos)
319 
320                 // Divide [prod1 prod0] by twos.
321                 prod0 := div(prod0, twos)
322 
323                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
324                 twos := add(div(sub(0, twos), twos), 1)
325             }
326 
327             // Shift in bits from prod1 into prod0.
328             prod0 |= prod1 * twos;
329 
330             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
331             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
332             // four bits. That is, denominator * inv = 1 mod 2^4.
333             uint256 inverse = (3 * denominator) ^ 2;
334 
335             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
336             // in modular arithmetic, doubling the correct bits in each step.
337             inverse *= 2 - denominator * inverse; // inverse mod 2^8
338             inverse *= 2 - denominator * inverse; // inverse mod 2^16
339             inverse *= 2 - denominator * inverse; // inverse mod 2^32
340             inverse *= 2 - denominator * inverse; // inverse mod 2^64
341             inverse *= 2 - denominator * inverse; // inverse mod 2^128
342             inverse *= 2 - denominator * inverse; // inverse mod 2^256
343 
344             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
345             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
346             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
347             // is no longer required.
348             result = prod0 * inverse;
349             return result;
350         }
351     }
352 
353     /**
354      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
355      */
356     function mulDiv(
357         uint256 x,
358         uint256 y,
359         uint256 denominator,
360         Rounding rounding
361     ) internal pure returns (uint256) {
362         uint256 result = mulDiv(x, y, denominator);
363         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
364             result += 1;
365         }
366         return result;
367     }
368 
369     /**
370      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
371      *
372      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
373      */
374     function sqrt(uint256 a) internal pure returns (uint256) {
375         if (a == 0) {
376             return 0;
377         }
378 
379         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
380         //
381         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
382         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
383         //
384         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
385         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
386         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
387         //
388         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
389         uint256 result = 1 << (log2(a) >> 1);
390 
391         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
392         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
393         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
394         // into the expected uint128 result.
395         unchecked {
396             result = (result + a / result) >> 1;
397             result = (result + a / result) >> 1;
398             result = (result + a / result) >> 1;
399             result = (result + a / result) >> 1;
400             result = (result + a / result) >> 1;
401             result = (result + a / result) >> 1;
402             result = (result + a / result) >> 1;
403             return min(result, a / result);
404         }
405     }
406 
407     /**
408      * @notice Calculates sqrt(a), following the selected rounding direction.
409      */
410     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
411         unchecked {
412             uint256 result = sqrt(a);
413             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
414         }
415     }
416 
417     /**
418      * @dev Return the log in base 2, rounded down, of a positive value.
419      * Returns 0 if given 0.
420      */
421     function log2(uint256 value) internal pure returns (uint256) {
422         uint256 result = 0;
423         unchecked {
424             if (value >> 128 > 0) {
425                 value >>= 128;
426                 result += 128;
427             }
428             if (value >> 64 > 0) {
429                 value >>= 64;
430                 result += 64;
431             }
432             if (value >> 32 > 0) {
433                 value >>= 32;
434                 result += 32;
435             }
436             if (value >> 16 > 0) {
437                 value >>= 16;
438                 result += 16;
439             }
440             if (value >> 8 > 0) {
441                 value >>= 8;
442                 result += 8;
443             }
444             if (value >> 4 > 0) {
445                 value >>= 4;
446                 result += 4;
447             }
448             if (value >> 2 > 0) {
449                 value >>= 2;
450                 result += 2;
451             }
452             if (value >> 1 > 0) {
453                 result += 1;
454             }
455         }
456         return result;
457     }
458 
459     /**
460      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
461      * Returns 0 if given 0.
462      */
463     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
464         unchecked {
465             uint256 result = log2(value);
466             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
467         }
468     }
469 
470     /**
471      * @dev Return the log in base 10, rounded down, of a positive value.
472      * Returns 0 if given 0.
473      */
474     function log10(uint256 value) internal pure returns (uint256) {
475         uint256 result = 0;
476         unchecked {
477             if (value >= 10**64) {
478                 value /= 10**64;
479                 result += 64;
480             }
481             if (value >= 10**32) {
482                 value /= 10**32;
483                 result += 32;
484             }
485             if (value >= 10**16) {
486                 value /= 10**16;
487                 result += 16;
488             }
489             if (value >= 10**8) {
490                 value /= 10**8;
491                 result += 8;
492             }
493             if (value >= 10**4) {
494                 value /= 10**4;
495                 result += 4;
496             }
497             if (value >= 10**2) {
498                 value /= 10**2;
499                 result += 2;
500             }
501             if (value >= 10**1) {
502                 result += 1;
503             }
504         }
505         return result;
506     }
507 
508     /**
509      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
510      * Returns 0 if given 0.
511      */
512     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
513         unchecked {
514             uint256 result = log10(value);
515             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
516         }
517     }
518 
519     /**
520      * @dev Return the log in base 256, rounded down, of a positive value.
521      * Returns 0 if given 0.
522      *
523      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
524      */
525     function log256(uint256 value) internal pure returns (uint256) {
526         uint256 result = 0;
527         unchecked {
528             if (value >> 128 > 0) {
529                 value >>= 128;
530                 result += 16;
531             }
532             if (value >> 64 > 0) {
533                 value >>= 64;
534                 result += 8;
535             }
536             if (value >> 32 > 0) {
537                 value >>= 32;
538                 result += 4;
539             }
540             if (value >> 16 > 0) {
541                 value >>= 16;
542                 result += 2;
543             }
544             if (value >> 8 > 0) {
545                 result += 1;
546             }
547         }
548         return result;
549     }
550 
551     /**
552      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
553      * Returns 0 if given 0.
554      */
555     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
556         unchecked {
557             uint256 result = log256(value);
558             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
559         }
560     }
561 }
562 
563 /**
564  * @dev String operations.
565  */
566 library Strings {
567     bytes16 private constant _SYMBOLS = "0123456789abcdef";
568     uint8 private constant _ADDRESS_LENGTH = 20;
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
572      */
573     function toString(uint256 value) internal pure returns (string memory) {
574         unchecked {
575             uint256 length = Math.log10(value) + 1;
576             string memory buffer = new string(length);
577             uint256 ptr;
578             /// @solidity memory-safe-assembly
579             assembly {
580                 ptr := add(buffer, add(32, length))
581             }
582             while (true) {
583                 ptr--;
584                 /// @solidity memory-safe-assembly
585                 assembly {
586                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
587                 }
588                 value /= 10;
589                 if (value == 0) break;
590             }
591             return buffer;
592         }
593     }
594 
595     /**
596      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
597      */
598     function toHexString(uint256 value) internal pure returns (string memory) {
599         unchecked {
600             return toHexString(value, Math.log256(value) + 1);
601         }
602     }
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
606      */
607     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
608         bytes memory buffer = new bytes(2 * length + 2);
609         buffer[0] = "0";
610         buffer[1] = "x";
611         for (uint256 i = 2 * length + 1; i > 1; --i) {
612             buffer[i] = _SYMBOLS[value & 0xf];
613             value >>= 4;
614         }
615         require(value == 0, "Strings: hex length insufficient");
616         return string(buffer);
617     }
618 
619     /**
620      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
621      */
622     function toHexString(address addr) internal pure returns (string memory) {
623         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
624     }
625 }
626 
627 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
630 
631 /**
632  * @dev Provides information about the current execution context, including the
633  * sender of the transaction and its data. While these are generally available
634  * via msg.sender and msg.data, they should not be accessed in such a direct
635  * manner, since when dealing with meta-transactions the account sending and
636  * paying for execution may not be the actual sender (as far as an application
637  * is concerned).
638  *
639  * This contract is only required for intermediate, library-like contracts.
640  */
641 abstract contract Context {
642     function _msgSender() internal view virtual returns (address) {
643         return msg.sender;
644     }
645 
646     function _msgData() internal view virtual returns (bytes calldata) {
647         return msg.data;
648     }
649 }
650 
651 /**
652  * @dev Contract module which provides a basic access control mechanism, where
653  * there is an account (an owner) that can be granted exclusive access to
654  * specific functions.
655  *
656  * By default, the owner account will be the one that deploys the contract. This
657  * can later be changed with {transferOwnership}.
658  *
659  * This module is used through inheritance. It will make available the modifier
660  * `onlyOwner`, which can be applied to your functions to restrict their use to
661  * the owner.
662  */
663 abstract contract Ownable is Context {
664     address private _owner;
665 
666     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
667 
668     /**
669      * @dev Initializes the contract setting the deployer as the initial owner.
670      */
671     constructor() {
672         _transferOwnership(_msgSender());
673     }
674 
675     /**
676      * @dev Throws if called by any account other than the owner.
677      */
678     modifier onlyOwner() {
679         _checkOwner();
680         _;
681     }
682 
683     /**
684      * @dev Returns the address of the current owner.
685      */
686     function owner() public view virtual returns (address) {
687         return _owner;
688     }
689 
690     /**
691      * @dev Throws if the sender is not the owner.
692      */
693     function _checkOwner() internal view virtual {
694         require(owner() == _msgSender(), "Ownable: caller is not the owner");
695     }
696 
697     /**
698      * @dev Leaves the contract without owner. It will not be possible to call
699      * `onlyOwner` functions anymore. Can only be called by the current owner.
700      *
701      * NOTE: Renouncing ownership will leave the contract without an owner,
702      * thereby removing any functionality that is only available to the owner.
703      */
704     function renounceOwnership() public virtual onlyOwner {
705         _transferOwnership(address(0));
706     }
707 
708     /**
709      * @dev Transfers ownership of the contract to a new account (`newOwner`).
710      * Can only be called by the current owner.
711      */
712     function transferOwnership(address newOwner) public virtual onlyOwner {
713         require(newOwner != address(0), "Ownable: new owner is the zero address");
714         _transferOwnership(newOwner);
715     }
716 
717     /**
718      * @dev Transfers ownership of the contract to a new account (`newOwner`).
719      * Internal function without access restriction.
720      */
721     function _transferOwnership(address newOwner) internal virtual {
722         address oldOwner = _owner;
723         _owner = newOwner;
724         emit OwnershipTransferred(oldOwner, newOwner);
725     }
726 }
727 
728 /// @notice Gas optimized reentrancy protection for smart contracts.
729 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
730 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
731 abstract contract ReentrancyGuard {
732     uint256 private locked = 1;
733 
734     modifier nonReentrant() {
735         require(locked == 1, "REENTRANCY");
736 
737         locked = 2;
738 
739         _;
740 
741         locked = 1;
742     }
743 }
744 
745 /// @title Mintable ERC721 Metakicks Portal Key
746 contract PortalKey is ERC721, Ownable, ReentrancyGuard {
747     using Strings for uint256;
748 
749     enum SaleStatus {
750         NotStarted,
751         Whitelist,
752         Public,
753         Migration
754     }
755 
756     /*///////////////////////////////////////////////////////////////
757                               EVENTS
758     //////////////////////////////////////////////////////////////*/
759 
760     /// @dev Emitted when the mint price is updated
761     /// @param mintPrice The new mintPrice
762     event MintPriceUpdated(uint256 mintPrice);
763 
764     /// @dev Emitted when the current sale status is updated
765     /// @param status The new sale status
766     event CurrentSaleStatusUpdated(SaleStatus status);
767 
768     /// @dev Emitted when the baseURI is updated
769     /// @param baseURI The new baseURI
770     event BaseUriUpdated(string baseURI);
771 
772     /// @dev Emitted when maxPerTx is updated
773     /// @param maxPerTx The new maxPerTx
774     event MaxPerTxUpdated(uint256 maxPerTx);
775 
776     /// @dev Emitted when the funds are withdrawed to the treasury
777     /// @param amount The amount withdrawed
778     event FundsWithdrawed(uint256 amount);
779 
780     /*///////////////////////////////////////////////////////////////
781                         IMMUTABLE/CONSTANTS
782     //////////////////////////////////////////////////////////////*/
783 
784     /// @notice Treasury (multisig) address to receiving the funds
785     address public immutable treasury;
786 
787     /// @notice Max amount, can't mint more
788     uint256 public constant MAX_AMOUNT = 555;
789 
790     /*///////////////////////////////////////////////////////////////
791                              VARIABLES
792     //////////////////////////////////////////////////////////////*/
793 
794     /// @notice The mint price for each key
795     uint256 public mintPrice = 0.15 ether;
796 
797     /// @notice Current tokenID
798     uint256 public currentTokenId;
799 
800     /// @notice Max amount to mint per address (public sale)
801     uint256 public maxPerTx = 2;
802 
803     /// @notice baseURI for the keys
804     string public baseURI;
805 
806     /// @notice Current sale status (inital is "NotStarted")
807     SaleStatus public currentSaleStatus;
808 
809     /// @notice Whitelisted addresses with allowed quantity to mint (whitelist sale)
810     mapping(address => uint256) public whitelist;
811 
812     /// @notice Whitelisted addresses with allowed quantity to mint (private sale)
813     mapping(address => uint256) public privateList;
814 
815     /// @notice Addresses that have already minted (public sale) with the amount.
816     mapping(address => uint256) public minted;
817 
818     /*///////////////////////////////////////////////////////////////
819                              CONSTRUCTOR
820     //////////////////////////////////////////////////////////////*/
821 
822     constructor(string memory _baseURI, address _treasury)
823         ERC721("Metakicks Portal Key", "MTKSKEY")
824     {
825         require(_treasury != address(0), "Invalid address");
826         baseURI = _baseURI;
827         treasury = _treasury;
828     }
829 
830     /*///////////////////////////////////////////////////////////////
831                            METADATA LOGIC
832     //////////////////////////////////////////////////////////////*/
833 
834     /// @inheritdoc ERC721
835     function tokenURI(uint256 tokenId)
836         public
837         view
838         override
839         returns (string memory)
840     {
841         return
842             bytes(baseURI).length > 0
843                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
844                 : "";
845     }
846 
847     /*///////////////////////////////////////////////////////////////
848                            MINT FUNCTIONS
849     //////////////////////////////////////////////////////////////*/
850 
851     /// @notice Public sale, 1 Token/Amount per users
852     /// @param amount The amount to mint (ERC1155 amount)
853     function publicSale(uint256 amount) external payable nonReentrant {
854         _publicSale(msg.value, amount, msg.sender);
855     }
856 
857     /// @notice Public sale, 1 Token/Amount per users
858     /// @param amount The amount to mint (ERC1155 amount)
859     /// @param to The address receiving the Portal Key
860     function publicSale(uint256 amount, address to)
861         external
862         payable
863         nonReentrant
864     {
865         _publicSale(msg.value, amount, to);
866     }
867 
868     /// @notice Whitelist sale for whitelisted users
869     /// @param amount The amount to mint
870     /// Note: Will mint the amount specified during the whitelist (by the owner)
871     function whitelistSale(uint256 amount) external payable nonReentrant {
872         _whitelistSale(msg.value, msg.sender, amount);
873     }
874 
875     /// @notice Whitelist sale for whitelisted users
876     /// @param amount The amount to mint
877     /// @param to The address receiving the Portal Key
878     /// Note: Will mint the amount specified during the whitelist (by the owner)
879     function whitelistSale(uint256 amount, address to)
880         external
881         payable
882         nonReentrant
883     {
884         _whitelistSale(msg.value, to, amount);
885     }
886 
887     /// @notice Private sale (free)
888     /// Note: Will mint the amount specified while adding to the private list
889     ///       (by the owner). The private sale is during the whitelist sale.
890     function privateSale() external nonReentrant {
891         require(
892             currentSaleStatus == SaleStatus.Whitelist,
893             "MINT: not in private sale"
894         );
895         uint256 amount = privateList[msg.sender];
896         require(amount != 0, "MINT: Not allowed");
897         require(
898             currentTokenId + amount <= MAX_AMOUNT,
899             "MINT: Max amount reached"
900         );
901 
902         privateList[msg.sender] = 0;
903         unchecked {
904             minted[msg.sender] += amount;
905         }
906 
907         for (uint256 i = 0; i < amount; ++i) {
908             unchecked {
909                 currentTokenId++;
910             }
911             _safeMint(msg.sender, currentTokenId);
912         }
913     }
914 
915     /*///////////////////////////////////////////////////////////////
916                            OWNER FUNCTIONS
917     //////////////////////////////////////////////////////////////*/
918 
919     /// @notice Update the price for the Whitelist and Public Sale
920     /// @param _mintPrice The new mint price
921     function setMintPrice(uint256 _mintPrice) external onlyOwner {
922         mintPrice = _mintPrice;
923         emit MintPriceUpdated(_mintPrice);
924     }
925 
926     /// @notice Update the sale status
927     /// @param _status The new status
928     function setCurrentSaleStatus(SaleStatus _status) external onlyOwner {
929         currentSaleStatus = _status;
930         emit CurrentSaleStatusUpdated(_status);
931     }
932 
933     /// @notice Update the maximum amount per Tx (public sale)
934     /// @param _maxPerTx The new amount
935     function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
936         require(_maxPerTx != 0, "Invalid amount");
937         maxPerTx = _maxPerTx;
938         emit MaxPerTxUpdated(_maxPerTx);
939     }
940 
941     /// @notice Add addresses to the whitelist
942     /// Note: If an address is already added, it will update the amount
943     /// @param addrs List of addresses to whitelist
944     /// @param amounts Respective amounts for each addresses
945     function addToWhitelist(address[] memory addrs, uint256[] memory amounts)
946         external
947         onlyOwner
948     {
949         require(addrs.length == amounts.length, "Length error");
950         uint256 length = addrs.length;
951         for (uint256 i; i < length; ) {
952             whitelist[addrs[i]] = amounts[i];
953             unchecked {
954                 i++;
955             }
956         }
957     }
958 
959     /// @notice Add addresses to the private list
960     /// Note: If an address is already added, it will update the amount
961     /// @param addrs List of addresses to add to the private list
962     /// @param amounts Respective amounts for each addresses
963     function addToPrivateList(address[] memory addrs, uint256[] memory amounts)
964         external
965         onlyOwner
966     {
967         require(addrs.length == amounts.length, "Length error");
968         uint256 length = addrs.length;
969         for (uint256 i; i < length; ) {
970             privateList[addrs[i]] = amounts[i];
971             unchecked {
972                 i++;
973             }
974         }
975     }
976 
977     /// @notice Update the baseURI
978     /// @param _baseURI the new _baseURI
979     function setBaseUri(string memory _baseURI) external onlyOwner {
980         baseURI = _baseURI;
981         emit BaseUriUpdated(_baseURI);
982     }
983 
984     /// @notice Allow the owner to withdraw the funds from the sale.
985     function withdrawFunds() external onlyOwner {
986         uint256 toWithdraw = address(this).balance;
987         payable(treasury).transfer(toWithdraw);
988         emit FundsWithdrawed(toWithdraw);
989     }
990 
991     /*///////////////////////////////////////////////////////////////
992                           PRIVATE FUNCTIONS
993     //////////////////////////////////////////////////////////////*/
994 
995     function _publicSale(
996         uint256 msgValue,
997         uint256 amount,
998         address to
999     ) private {
1000         require(amount != 0, "MINT: invalid amount");
1001         require(
1002             currentSaleStatus == SaleStatus.Public,
1003             "MINT: not in public sale"
1004         );
1005         require(minted[to] + amount <= maxPerTx, "MINT: Can't mint more");
1006         require(msgValue >= mintPrice * amount, "MINT: Not enough eth");
1007         require(
1008             currentTokenId + amount <= MAX_AMOUNT,
1009             "MINT: Max amount reached"
1010         );
1011 
1012         unchecked {
1013             minted[to] += amount;
1014         }
1015 
1016         for (uint256 i = 0; i < amount; ++i) {
1017             unchecked {
1018                 currentTokenId++;
1019             }
1020             _safeMint(to, currentTokenId);
1021         }
1022     }
1023 
1024     function _whitelistSale(
1025         uint256 msgValue,
1026         address to,
1027         uint256 amount
1028     ) private {
1029         require(
1030             currentSaleStatus == SaleStatus.Whitelist,
1031             "MINT: not in whitelist sale"
1032         );
1033         uint256 amountAllowed = whitelist[to];
1034         require(amount != 0 && amount <= amountAllowed, "MINT: Not allowed");
1035         require(msgValue >= mintPrice * amount, "MINT: Not enough eth");
1036         require(
1037             currentTokenId + amount <= MAX_AMOUNT,
1038             "MINT: Max amount reached"
1039         );
1040 
1041         whitelist[to] -= amount;
1042 
1043         unchecked {
1044             minted[to] += amount;
1045         }
1046 
1047         for (uint256 i = 0; i < amount; ++i) {
1048             unchecked {
1049                 currentTokenId++;
1050             }
1051             _safeMint(to, currentTokenId);
1052         }
1053     }
1054 }