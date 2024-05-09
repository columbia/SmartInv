1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 
5 // ====================================================================
6 // |     ______                   _______                             |
7 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
8 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
9 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
10 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
11 // |                                                                  |
12 // ====================================================================
13 // ============================== sfrxETH =============================
14 // ====================================================================
15 // Frax Finance: https://github.com/FraxFinance
16 
17 // Primary Author(s)
18 // Jack Corddry: https://github.com/corddry
19 // Nader Ghazvini: https://github.com/amirnader-ghazvini 
20 
21 // Reviewer(s) / Contributor(s)
22 // Sam Kazemian: https://github.com/samkazemian
23 // Dennett: https://github.com/denett
24 // Travis Moore: https://github.com/FortisFortuna
25 // Jamie Turley: https://github.com/jyturley
26 
27 // Rewards logic inspired by xERC20 (https://github.com/ZeframLou/playpen/blob/main/src/xERC20.sol)
28 
29 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
30 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
31 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
32 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
33 abstract contract ERC20 {
34     /*//////////////////////////////////////////////////////////////
35                                  EVENTS
36     //////////////////////////////////////////////////////////////*/
37 
38     event Transfer(address indexed from, address indexed to, uint256 amount);
39 
40     event Approval(address indexed owner, address indexed spender, uint256 amount);
41 
42     /*//////////////////////////////////////////////////////////////
43                             METADATA STORAGE
44     //////////////////////////////////////////////////////////////*/
45 
46     string public name;
47 
48     string public symbol;
49 
50     uint8 public immutable decimals;
51 
52     /*//////////////////////////////////////////////////////////////
53                               ERC20 STORAGE
54     //////////////////////////////////////////////////////////////*/
55 
56     uint256 public totalSupply;
57 
58     mapping(address => uint256) public balanceOf;
59 
60     mapping(address => mapping(address => uint256)) public allowance;
61 
62     /*//////////////////////////////////////////////////////////////
63                             EIP-2612 STORAGE
64     //////////////////////////////////////////////////////////////*/
65 
66     uint256 internal immutable INITIAL_CHAIN_ID;
67 
68     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
69 
70     mapping(address => uint256) public nonces;
71 
72     /*//////////////////////////////////////////////////////////////
73                                CONSTRUCTOR
74     //////////////////////////////////////////////////////////////*/
75 
76     constructor(
77         string memory _name,
78         string memory _symbol,
79         uint8 _decimals
80     ) {
81         name = _name;
82         symbol = _symbol;
83         decimals = _decimals;
84 
85         INITIAL_CHAIN_ID = block.chainid;
86         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
87     }
88 
89     /*//////////////////////////////////////////////////////////////
90                                ERC20 LOGIC
91     //////////////////////////////////////////////////////////////*/
92 
93     function approve(address spender, uint256 amount) public virtual returns (bool) {
94         allowance[msg.sender][spender] = amount;
95 
96         emit Approval(msg.sender, spender, amount);
97 
98         return true;
99     }
100 
101     function transfer(address to, uint256 amount) public virtual returns (bool) {
102         balanceOf[msg.sender] -= amount;
103 
104         // Cannot overflow because the sum of all user
105         // balances can't exceed the max uint256 value.
106         unchecked {
107             balanceOf[to] += amount;
108         }
109 
110         emit Transfer(msg.sender, to, amount);
111 
112         return true;
113     }
114 
115     function transferFrom(
116         address from,
117         address to,
118         uint256 amount
119     ) public virtual returns (bool) {
120         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
121 
122         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
123 
124         balanceOf[from] -= amount;
125 
126         // Cannot overflow because the sum of all user
127         // balances can't exceed the max uint256 value.
128         unchecked {
129             balanceOf[to] += amount;
130         }
131 
132         emit Transfer(from, to, amount);
133 
134         return true;
135     }
136 
137     /*//////////////////////////////////////////////////////////////
138                              EIP-2612 LOGIC
139     //////////////////////////////////////////////////////////////*/
140 
141     function permit(
142         address owner,
143         address spender,
144         uint256 value,
145         uint256 deadline,
146         uint8 v,
147         bytes32 r,
148         bytes32 s
149     ) public virtual {
150         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
151 
152         // Unchecked because the only math done is incrementing
153         // the owner's nonce which cannot realistically overflow.
154         unchecked {
155             address recoveredAddress = ecrecover(
156                 keccak256(
157                     abi.encodePacked(
158                         "\x19\x01",
159                         DOMAIN_SEPARATOR(),
160                         keccak256(
161                             abi.encode(
162                                 keccak256(
163                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
164                                 ),
165                                 owner,
166                                 spender,
167                                 value,
168                                 nonces[owner]++,
169                                 deadline
170                             )
171                         )
172                     )
173                 ),
174                 v,
175                 r,
176                 s
177             );
178 
179             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
180 
181             allowance[recoveredAddress][spender] = value;
182         }
183 
184         emit Approval(owner, spender, value);
185     }
186 
187     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
188         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
189     }
190 
191     function computeDomainSeparator() internal view virtual returns (bytes32) {
192         return
193             keccak256(
194                 abi.encode(
195                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
196                     keccak256(bytes(name)),
197                     keccak256("1"),
198                     block.chainid,
199                     address(this)
200                 )
201             );
202     }
203 
204     /*//////////////////////////////////////////////////////////////
205                         INTERNAL MINT/BURN LOGIC
206     //////////////////////////////////////////////////////////////*/
207 
208     function _mint(address to, uint256 amount) internal virtual {
209         totalSupply += amount;
210 
211         // Cannot overflow because the sum of all user
212         // balances can't exceed the max uint256 value.
213         unchecked {
214             balanceOf[to] += amount;
215         }
216 
217         emit Transfer(address(0), to, amount);
218     }
219 
220     function _burn(address from, uint256 amount) internal virtual {
221         balanceOf[from] -= amount;
222 
223         // Cannot underflow because a user's balance
224         // will never be larger than the total supply.
225         unchecked {
226             totalSupply -= amount;
227         }
228 
229         emit Transfer(from, address(0), amount);
230     }
231 }
232 
233 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
234 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
235 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
236 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
237 library SafeTransferLib {
238     /*//////////////////////////////////////////////////////////////
239                              ETH OPERATIONS
240     //////////////////////////////////////////////////////////////*/
241 
242     function safeTransferETH(address to, uint256 amount) internal {
243         bool success;
244 
245         assembly {
246             // Transfer the ETH and store if it succeeded or not.
247             success := call(gas(), to, amount, 0, 0, 0, 0)
248         }
249 
250         require(success, "ETH_TRANSFER_FAILED");
251     }
252 
253     /*//////////////////////////////////////////////////////////////
254                             ERC20 OPERATIONS
255     //////////////////////////////////////////////////////////////*/
256 
257     function safeTransferFrom(
258         ERC20 token,
259         address from,
260         address to,
261         uint256 amount
262     ) internal {
263         bool success;
264 
265         assembly {
266             // Get a pointer to some free memory.
267             let freeMemoryPointer := mload(0x40)
268 
269             // Write the abi-encoded calldata into memory, beginning with the function selector.
270             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
271             mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
272             mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
273             mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
274 
275             success := and(
276                 // Set success to whether the call reverted, if not we check it either
277                 // returned exactly 1 (can't just be non-zero data), or had no return data.
278                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
279                 // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
280                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
281                 // Counterintuitively, this call must be positioned second to the or() call in the
282                 // surrounding and() call or else returndatasize() will be zero during the computation.
283                 call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
284             )
285         }
286 
287         require(success, "TRANSFER_FROM_FAILED");
288     }
289 
290     function safeTransfer(
291         ERC20 token,
292         address to,
293         uint256 amount
294     ) internal {
295         bool success;
296 
297         assembly {
298             // Get a pointer to some free memory.
299             let freeMemoryPointer := mload(0x40)
300 
301             // Write the abi-encoded calldata into memory, beginning with the function selector.
302             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
303             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
304             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
305 
306             success := and(
307                 // Set success to whether the call reverted, if not we check it either
308                 // returned exactly 1 (can't just be non-zero data), or had no return data.
309                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
310                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
311                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
312                 // Counterintuitively, this call must be positioned second to the or() call in the
313                 // surrounding and() call or else returndatasize() will be zero during the computation.
314                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
315             )
316         }
317 
318         require(success, "TRANSFER_FAILED");
319     }
320 
321     function safeApprove(
322         ERC20 token,
323         address to,
324         uint256 amount
325     ) internal {
326         bool success;
327 
328         assembly {
329             // Get a pointer to some free memory.
330             let freeMemoryPointer := mload(0x40)
331 
332             // Write the abi-encoded calldata into memory, beginning with the function selector.
333             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
334             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
335             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
336 
337             success := and(
338                 // Set success to whether the call reverted, if not we check it either
339                 // returned exactly 1 (can't just be non-zero data), or had no return data.
340                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
341                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
342                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
343                 // Counterintuitively, this call must be positioned second to the or() call in the
344                 // surrounding and() call or else returndatasize() will be zero during the computation.
345                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
346             )
347         }
348 
349         require(success, "APPROVE_FAILED");
350     }
351 }
352 
353 /// @notice Arithmetic library with operations for fixed-point numbers.
354 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
355 /// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
356 library FixedPointMathLib {
357     /*//////////////////////////////////////////////////////////////
358                     SIMPLIFIED FIXED POINT OPERATIONS
359     //////////////////////////////////////////////////////////////*/
360 
361     uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.
362 
363     function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
364         return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
365     }
366 
367     function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
368         return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
369     }
370 
371     function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
372         return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
373     }
374 
375     function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
376         return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
377     }
378 
379     /*//////////////////////////////////////////////////////////////
380                     LOW LEVEL FIXED POINT OPERATIONS
381     //////////////////////////////////////////////////////////////*/
382 
383     function mulDivDown(
384         uint256 x,
385         uint256 y,
386         uint256 denominator
387     ) internal pure returns (uint256 z) {
388         assembly {
389             // Store x * y in z for now.
390             z := mul(x, y)
391 
392             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
393             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
394                 revert(0, 0)
395             }
396 
397             // Divide z by the denominator.
398             z := div(z, denominator)
399         }
400     }
401 
402     function mulDivUp(
403         uint256 x,
404         uint256 y,
405         uint256 denominator
406     ) internal pure returns (uint256 z) {
407         assembly {
408             // Store x * y in z for now.
409             z := mul(x, y)
410 
411             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
412             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
413                 revert(0, 0)
414             }
415 
416             // First, divide z - 1 by the denominator and add 1.
417             // We allow z - 1 to underflow if z is 0, because we multiply the
418             // end result by 0 if z is zero, ensuring we return 0 if z is zero.
419             z := mul(iszero(iszero(z)), add(div(sub(z, 1), denominator), 1))
420         }
421     }
422 
423     function rpow(
424         uint256 x,
425         uint256 n,
426         uint256 scalar
427     ) internal pure returns (uint256 z) {
428         assembly {
429             switch x
430             case 0 {
431                 switch n
432                 case 0 {
433                     // 0 ** 0 = 1
434                     z := scalar
435                 }
436                 default {
437                     // 0 ** n = 0
438                     z := 0
439                 }
440             }
441             default {
442                 switch mod(n, 2)
443                 case 0 {
444                     // If n is even, store scalar in z for now.
445                     z := scalar
446                 }
447                 default {
448                     // If n is odd, store x in z for now.
449                     z := x
450                 }
451 
452                 // Shifting right by 1 is like dividing by 2.
453                 let half := shr(1, scalar)
454 
455                 for {
456                     // Shift n right by 1 before looping to halve it.
457                     n := shr(1, n)
458                 } n {
459                     // Shift n right by 1 each iteration to halve it.
460                     n := shr(1, n)
461                 } {
462                     // Revert immediately if x ** 2 would overflow.
463                     // Equivalent to iszero(eq(div(xx, x), x)) here.
464                     if shr(128, x) {
465                         revert(0, 0)
466                     }
467 
468                     // Store x squared.
469                     let xx := mul(x, x)
470 
471                     // Round to the nearest number.
472                     let xxRound := add(xx, half)
473 
474                     // Revert if xx + half overflowed.
475                     if lt(xxRound, xx) {
476                         revert(0, 0)
477                     }
478 
479                     // Set x to scaled xxRound.
480                     x := div(xxRound, scalar)
481 
482                     // If n is even:
483                     if mod(n, 2) {
484                         // Compute z * x.
485                         let zx := mul(z, x)
486 
487                         // If z * x overflowed:
488                         if iszero(eq(div(zx, x), z)) {
489                             // Revert if x is non-zero.
490                             if iszero(iszero(x)) {
491                                 revert(0, 0)
492                             }
493                         }
494 
495                         // Round to the nearest number.
496                         let zxRound := add(zx, half)
497 
498                         // Revert if zx + half overflowed.
499                         if lt(zxRound, zx) {
500                             revert(0, 0)
501                         }
502 
503                         // Return properly scaled zxRound.
504                         z := div(zxRound, scalar)
505                     }
506                 }
507             }
508         }
509     }
510 
511     /*//////////////////////////////////////////////////////////////
512                         GENERAL NUMBER UTILITIES
513     //////////////////////////////////////////////////////////////*/
514 
515     function sqrt(uint256 x) internal pure returns (uint256 z) {
516         assembly {
517             let y := x // We start y at x, which will help us make our initial estimate.
518 
519             z := 181 // The "correct" value is 1, but this saves a multiplication later.
520 
521             // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
522             // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.
523 
524             // We check y >= 2^(k + 8) but shift right by k bits
525             // each branch to ensure that if x >= 256, then y >= 256.
526             if iszero(lt(y, 0x10000000000000000000000000000000000)) {
527                 y := shr(128, y)
528                 z := shl(64, z)
529             }
530             if iszero(lt(y, 0x1000000000000000000)) {
531                 y := shr(64, y)
532                 z := shl(32, z)
533             }
534             if iszero(lt(y, 0x10000000000)) {
535                 y := shr(32, y)
536                 z := shl(16, z)
537             }
538             if iszero(lt(y, 0x1000000)) {
539                 y := shr(16, y)
540                 z := shl(8, z)
541             }
542 
543             // Goal was to get z*z*y within a small factor of x. More iterations could
544             // get y in a tighter range. Currently, we will have y in [256, 256*2^16).
545             // We ensured y >= 256 so that the relative difference between y and y+1 is small.
546             // That's not possible if x < 256 but we can just verify those cases exhaustively.
547 
548             // Now, z*z*y <= x < z*z*(y+1), and y <= 2^(16+8), and either y >= 256, or x < 256.
549             // Correctness can be checked exhaustively for x < 256, so we assume y >= 256.
550             // Then z*sqrt(y) is within sqrt(257)/sqrt(256) of sqrt(x), or about 20bps.
551 
552             // For s in the range [1/256, 256], the estimate f(s) = (181/1024) * (s+1) is in the range
553             // (1/2.84 * sqrt(s), 2.84 * sqrt(s)), with largest error when s = 1 and when s = 256 or 1/256.
554 
555             // Since y is in [256, 256*2^16), let a = y/65536, so that a is in [1/256, 256). Then we can estimate
556             // sqrt(y) using sqrt(65536) * 181/1024 * (a + 1) = 181/4 * (y + 65536)/65536 = 181 * (y + 65536)/2^18.
557 
558             // There is no overflow risk here since y < 2^136 after the first branch above.
559             z := shr(18, mul(z, add(y, 65536))) // A mul() is saved from starting z at 181.
560 
561             // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
562             z := shr(1, add(z, div(x, z)))
563             z := shr(1, add(z, div(x, z)))
564             z := shr(1, add(z, div(x, z)))
565             z := shr(1, add(z, div(x, z)))
566             z := shr(1, add(z, div(x, z)))
567             z := shr(1, add(z, div(x, z)))
568             z := shr(1, add(z, div(x, z)))
569 
570             // If x+1 is a perfect square, the Babylonian method cycles between
571             // floor(sqrt(x)) and ceil(sqrt(x)). This statement ensures we return floor.
572             // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
573             // Since the ceil is rare, we save gas on the assignment and repeat division in the rare case.
574             // If you don't care whether the floor or ceil square root is returned, you can remove this statement.
575             z := sub(z, lt(div(x, z), z))
576         }
577     }
578 
579     function unsafeMod(uint256 x, uint256 y) internal pure returns (uint256 z) {
580         assembly {
581             // Mod x by y. Note this will return
582             // 0 instead of reverting if y is zero.
583             z := mod(x, y)
584         }
585     }
586 
587     function unsafeDiv(uint256 x, uint256 y) internal pure returns (uint256 r) {
588         assembly {
589             // Divide x by y. Note this will return
590             // 0 instead of reverting if y is zero.
591             r := div(x, y)
592         }
593     }
594 
595     function unsafeDivUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
596         assembly {
597             // Add 1 to x * y if x % y > 0. Note this will
598             // return 0 instead of reverting if y is zero.
599             z := add(gt(mod(x, y), 0), div(x, y))
600         }
601     }
602 }
603 
604 /// @notice Minimal ERC4626 tokenized Vault implementation.
605 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/mixins/ERC4626.sol)
606 abstract contract ERC4626 is ERC20 {
607     using SafeTransferLib for ERC20;
608     using FixedPointMathLib for uint256;
609 
610     /*//////////////////////////////////////////////////////////////
611                                  EVENTS
612     //////////////////////////////////////////////////////////////*/
613 
614     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
615 
616     event Withdraw(
617         address indexed caller,
618         address indexed receiver,
619         address indexed owner,
620         uint256 assets,
621         uint256 shares
622     );
623 
624     /*//////////////////////////////////////////////////////////////
625                                IMMUTABLES
626     //////////////////////////////////////////////////////////////*/
627 
628     ERC20 public immutable asset;
629 
630     constructor(
631         ERC20 _asset,
632         string memory _name,
633         string memory _symbol
634     ) ERC20(_name, _symbol, _asset.decimals()) {
635         asset = _asset;
636     }
637 
638     /*//////////////////////////////////////////////////////////////
639                         DEPOSIT/WITHDRAWAL LOGIC
640     //////////////////////////////////////////////////////////////*/
641 
642     function deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
643         // Check for rounding error since we round down in previewDeposit.
644         require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");
645 
646         // Need to transfer before minting or ERC777s could reenter.
647         asset.safeTransferFrom(msg.sender, address(this), assets);
648 
649         _mint(receiver, shares);
650 
651         emit Deposit(msg.sender, receiver, assets, shares);
652 
653         afterDeposit(assets, shares);
654     }
655 
656     function mint(uint256 shares, address receiver) public virtual returns (uint256 assets) {
657         assets = previewMint(shares); // No need to check for rounding error, previewMint rounds up.
658 
659         // Need to transfer before minting or ERC777s could reenter.
660         asset.safeTransferFrom(msg.sender, address(this), assets);
661 
662         _mint(receiver, shares);
663 
664         emit Deposit(msg.sender, receiver, assets, shares);
665 
666         afterDeposit(assets, shares);
667     }
668 
669     function withdraw(
670         uint256 assets,
671         address receiver,
672         address owner
673     ) public virtual returns (uint256 shares) {
674         shares = previewWithdraw(assets); // No need to check for rounding error, previewWithdraw rounds up.
675 
676         if (msg.sender != owner) {
677             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
678 
679             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
680         }
681 
682         beforeWithdraw(assets, shares);
683 
684         _burn(owner, shares);
685 
686         emit Withdraw(msg.sender, receiver, owner, assets, shares);
687 
688         asset.safeTransfer(receiver, assets);
689     }
690 
691     function redeem(
692         uint256 shares,
693         address receiver,
694         address owner
695     ) public virtual returns (uint256 assets) {
696         if (msg.sender != owner) {
697             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
698 
699             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
700         }
701 
702         // Check for rounding error since we round down in previewRedeem.
703         require((assets = previewRedeem(shares)) != 0, "ZERO_ASSETS");
704 
705         beforeWithdraw(assets, shares);
706 
707         _burn(owner, shares);
708 
709         emit Withdraw(msg.sender, receiver, owner, assets, shares);
710 
711         asset.safeTransfer(receiver, assets);
712     }
713 
714     /*//////////////////////////////////////////////////////////////
715                             ACCOUNTING LOGIC
716     //////////////////////////////////////////////////////////////*/
717 
718     function totalAssets() public view virtual returns (uint256);
719 
720     function convertToShares(uint256 assets) public view virtual returns (uint256) {
721         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
722 
723         return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
724     }
725 
726     function convertToAssets(uint256 shares) public view virtual returns (uint256) {
727         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
728 
729         return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
730     }
731 
732     function previewDeposit(uint256 assets) public view virtual returns (uint256) {
733         return convertToShares(assets);
734     }
735 
736     function previewMint(uint256 shares) public view virtual returns (uint256) {
737         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
738 
739         return supply == 0 ? shares : shares.mulDivUp(totalAssets(), supply);
740     }
741 
742     function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
743         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
744 
745         return supply == 0 ? assets : assets.mulDivUp(supply, totalAssets());
746     }
747 
748     function previewRedeem(uint256 shares) public view virtual returns (uint256) {
749         return convertToAssets(shares);
750     }
751 
752     /*//////////////////////////////////////////////////////////////
753                      DEPOSIT/WITHDRAWAL LIMIT LOGIC
754     //////////////////////////////////////////////////////////////*/
755 
756     function maxDeposit(address) public view virtual returns (uint256) {
757         return type(uint256).max;
758     }
759 
760     function maxMint(address) public view virtual returns (uint256) {
761         return type(uint256).max;
762     }
763 
764     function maxWithdraw(address owner) public view virtual returns (uint256) {
765         return convertToAssets(balanceOf[owner]);
766     }
767 
768     function maxRedeem(address owner) public view virtual returns (uint256) {
769         return balanceOf[owner];
770     }
771 
772     /*//////////////////////////////////////////////////////////////
773                           INTERNAL HOOKS LOGIC
774     //////////////////////////////////////////////////////////////*/
775 
776     function beforeWithdraw(uint256 assets, uint256 shares) internal virtual {}
777 
778     function afterDeposit(uint256 assets, uint256 shares) internal virtual {}
779 }
780 
781 /// @notice Safe unsigned integer casting library that reverts on overflow.
782 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeCastLib.sol)
783 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeCast.sol)
784 library SafeCastLib {
785     function safeCastTo248(uint256 x) internal pure returns (uint248 y) {
786         require(x < 1 << 248);
787 
788         y = uint248(x);
789     }
790 
791     function safeCastTo224(uint256 x) internal pure returns (uint224 y) {
792         require(x < 1 << 224);
793 
794         y = uint224(x);
795     }
796 
797     function safeCastTo192(uint256 x) internal pure returns (uint192 y) {
798         require(x < 1 << 192);
799 
800         y = uint192(x);
801     }
802 
803     function safeCastTo160(uint256 x) internal pure returns (uint160 y) {
804         require(x < 1 << 160);
805 
806         y = uint160(x);
807     }
808 
809     function safeCastTo128(uint256 x) internal pure returns (uint128 y) {
810         require(x < 1 << 128);
811 
812         y = uint128(x);
813     }
814 
815     function safeCastTo96(uint256 x) internal pure returns (uint96 y) {
816         require(x < 1 << 96);
817 
818         y = uint96(x);
819     }
820 
821     function safeCastTo64(uint256 x) internal pure returns (uint64 y) {
822         require(x < 1 << 64);
823 
824         y = uint64(x);
825     }
826 
827     function safeCastTo32(uint256 x) internal pure returns (uint32 y) {
828         require(x < 1 << 32);
829 
830         y = uint32(x);
831     }
832 
833     function safeCastTo24(uint256 x) internal pure returns (uint24 y) {
834         require(x < 1 << 24);
835 
836         y = uint24(x);
837     }
838 
839     function safeCastTo16(uint256 x) internal pure returns (uint16 y) {
840         require(x < 1 << 16);
841 
842         y = uint16(x);
843     }
844 
845     function safeCastTo8(uint256 x) internal pure returns (uint8 y) {
846         require(x < 1 << 8);
847 
848         y = uint8(x);
849     }
850 }
851 
852 // Rewards logic inspired by xERC20 (https://github.com/ZeframLou/playpen/blob/main/src/xERC20.sol)
853 
854 /** 
855  @title  An xERC4626 Single Staking Contract Interface
856  @notice This contract allows users to autocompound rewards denominated in an underlying reward token. 
857          It is fully compatible with [ERC4626](https://eips.ethereum.org/EIPS/eip-4626) allowing for DeFi composability.
858          It maintains balances using internal accounting to prevent instantaneous changes in the exchange rate.
859          NOTE: an exception is at contract creation, when a reward cycle begins before the first deposit. After the first deposit, exchange rate updates smoothly.
860 
861          Operates on "cycles" which distribute the rewards surplus over the internal balance to users linearly over the remainder of the cycle window.
862 */
863 interface IxERC4626 {
864     /*////////////////////////////////////////////////////////
865                         Custom Errors
866     ////////////////////////////////////////////////////////*/
867 
868     /// @dev thrown when syncing before cycle ends.
869     error SyncError();
870 
871     /*////////////////////////////////////////////////////////
872                             Events
873     ////////////////////////////////////////////////////////*/
874 
875     /// @dev emit every time a new rewards cycle starts
876     event NewRewardsCycle(uint32 indexed cycleEnd, uint256 rewardAmount);
877 
878     /*////////////////////////////////////////////////////////
879                         View Methods
880     ////////////////////////////////////////////////////////*/
881 
882     /// @notice the maximum length of a rewards cycle
883     function rewardsCycleLength() external view returns (uint32);
884 
885     /// @notice the effective start of the current cycle
886     /// NOTE: This will likely be after `rewardsCycleEnd - rewardsCycleLength` as this is set as block.timestamp of the last `syncRewards` call.
887     function lastSync() external view returns (uint32);
888 
889     /// @notice the end of the current cycle. Will always be evenly divisible by `rewardsCycleLength`.
890     function rewardsCycleEnd() external view returns (uint32);
891 
892     /// @notice the amount of rewards distributed in a the most recent cycle
893     function lastRewardAmount() external view returns (uint192);
894 
895     /*////////////////////////////////////////////////////////
896                     State Changing Methods
897     ////////////////////////////////////////////////////////*/
898 
899     /// @notice Distributes rewards to xERC4626 holders.
900     /// All surplus `asset` balance of the contract over the internal balance becomes queued for the next cycle.
901     function syncRewards() external;
902 }
903 
904 /** 
905  @title  An xERC4626 Single Staking Contract
906  @notice This contract allows users to autocompound rewards denominated in an underlying reward token. 
907          It is fully compatible with [ERC4626](https://eips.ethereum.org/EIPS/eip-4626) allowing for DeFi composability.
908          It maintains balances using internal accounting to prevent instantaneous changes in the exchange rate.
909          NOTE: an exception is at contract creation, when a reward cycle begins before the first deposit. After the first deposit, exchange rate updates smoothly.
910 
911          Operates on "cycles" which distribute the rewards surplus over the internal balance to users linearly over the remainder of the cycle window.
912 */
913 abstract contract xERC4626 is IxERC4626, ERC4626 {
914     using SafeCastLib for *;
915 
916     /// @notice the maximum length of a rewards cycle
917     uint32 public immutable rewardsCycleLength;
918 
919     /// @notice the effective start of the current cycle
920     uint32 public lastSync;
921 
922     /// @notice the end of the current cycle. Will always be evenly divisible by `rewardsCycleLength`.
923     uint32 public rewardsCycleEnd;
924 
925     /// @notice the amount of rewards distributed in a the most recent cycle.
926     uint192 public lastRewardAmount;
927 
928     uint256 internal storedTotalAssets;
929 
930     constructor(uint32 _rewardsCycleLength) {
931         rewardsCycleLength = _rewardsCycleLength;
932         // seed initial rewardsCycleEnd
933         rewardsCycleEnd = (block.timestamp.safeCastTo32() / rewardsCycleLength) * rewardsCycleLength;
934     }
935 
936     /// @notice Compute the amount of tokens available to share holders.
937     ///         Increases linearly during a reward distribution period from the sync call, not the cycle start.
938     function totalAssets() public view override returns (uint256) {
939         // cache global vars
940         uint256 storedTotalAssets_ = storedTotalAssets;
941         uint192 lastRewardAmount_ = lastRewardAmount;
942         uint32 rewardsCycleEnd_ = rewardsCycleEnd;
943         uint32 lastSync_ = lastSync;
944 
945         if (block.timestamp >= rewardsCycleEnd_) {
946             // no rewards or rewards fully unlocked
947             // entire reward amount is available
948             return storedTotalAssets_ + lastRewardAmount_;
949         }
950 
951         // rewards not fully unlocked
952         // add unlocked rewards to stored total
953         uint256 unlockedRewards = (lastRewardAmount_ * (block.timestamp - lastSync_)) / (rewardsCycleEnd_ - lastSync_);
954         return storedTotalAssets_ + unlockedRewards;
955     }
956 
957     // Update storedTotalAssets on withdraw/redeem
958     function beforeWithdraw(uint256 amount, uint256 shares) internal virtual override {
959         super.beforeWithdraw(amount, shares);
960         storedTotalAssets -= amount;
961     }
962 
963     // Update storedTotalAssets on deposit/mint
964     function afterDeposit(uint256 amount, uint256 shares) internal virtual override {
965         storedTotalAssets += amount;
966         super.afterDeposit(amount, shares);
967     }
968 
969     /// @notice Distributes rewards to xERC4626 holders.
970     /// All surplus `asset` balance of the contract over the internal balance becomes queued for the next cycle.
971     function syncRewards() public virtual {
972         uint192 lastRewardAmount_ = lastRewardAmount;
973         uint32 timestamp = block.timestamp.safeCastTo32();
974 
975         if (timestamp < rewardsCycleEnd) revert SyncError();
976 
977         uint256 storedTotalAssets_ = storedTotalAssets;
978         uint256 nextRewards = asset.balanceOf(address(this)) - storedTotalAssets_ - lastRewardAmount_;
979 
980         storedTotalAssets = storedTotalAssets_ + lastRewardAmount_; // SSTORE
981 
982         uint32 end = ((timestamp + rewardsCycleLength) / rewardsCycleLength) * rewardsCycleLength;
983 
984         if (end - timestamp < rewardsCycleLength / 20) {
985             end += rewardsCycleLength;
986         }
987 
988         // Combined single SSTORE
989         lastRewardAmount = nextRewards.safeCastTo192();
990         lastSync = timestamp;
991         rewardsCycleEnd = end;
992 
993         emit NewRewardsCycle(end, nextRewards);
994     }
995 }
996 
997 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
998 
999 /**
1000  * @dev Contract module that helps prevent reentrant calls to a function.
1001  *
1002  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1003  * available, which can be applied to functions to make sure there are no nested
1004  * (reentrant) calls to them.
1005  *
1006  * Note that because there is a single `nonReentrant` guard, functions marked as
1007  * `nonReentrant` may not call one another. This can be worked around by making
1008  * those functions `private`, and then adding `external` `nonReentrant` entry
1009  * points to them.
1010  *
1011  * TIP: If you would like to learn more about reentrancy and alternative ways
1012  * to protect against it, check out our blog post
1013  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1014  */
1015 abstract contract ReentrancyGuard {
1016     // Booleans are more expensive than uint256 or any type that takes up a full
1017     // word because each write operation emits an extra SLOAD to first read the
1018     // slot's contents, replace the bits taken up by the boolean, and then write
1019     // back. This is the compiler's defense against contract upgrades and
1020     // pointer aliasing, and it cannot be disabled.
1021 
1022     // The values being non-zero value makes deployment a bit more expensive,
1023     // but in exchange the refund on every call to nonReentrant will be lower in
1024     // amount. Since refunds are capped to a percentage of the total
1025     // transaction's gas, it is best to keep them low in cases like this one, to
1026     // increase the likelihood of the full refund coming into effect.
1027     uint256 private constant _NOT_ENTERED = 1;
1028     uint256 private constant _ENTERED = 2;
1029 
1030     uint256 private _status;
1031 
1032     constructor() {
1033         _status = _NOT_ENTERED;
1034     }
1035 
1036     /**
1037      * @dev Prevents a contract from calling itself, directly or indirectly.
1038      * Calling a `nonReentrant` function from another `nonReentrant`
1039      * function is not supported. It is possible to prevent this from happening
1040      * by making the `nonReentrant` function external, and making it call a
1041      * `private` function that does the actual work.
1042      */
1043     modifier nonReentrant() {
1044         _nonReentrantBefore();
1045         _;
1046         _nonReentrantAfter();
1047     }
1048 
1049     function _nonReentrantBefore() private {
1050         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1051         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1052 
1053         // Any calls to nonReentrant after this point will fail
1054         _status = _ENTERED;
1055     }
1056 
1057     function _nonReentrantAfter() private {
1058         // By storing the original value once again, a refund is triggered (see
1059         // https://eips.ethereum.org/EIPS/eip-2200)
1060         _status = _NOT_ENTERED;
1061     }
1062 }
1063 
1064 /// @title Vault token for staked frxETH
1065 /// @notice Is a vault that takes frxETH and gives you sfrxETH erc20 tokens
1066 /** @dev Exchange rate between frxETH and sfrxETH floats, you can convert your sfrxETH for more frxETH over time.
1067     Exchange rate increases as the frax msig mints new frxETH corresponding to the staking yield and drops it into the vault (sfrxETH contract).
1068     There is a short time period, “cycles” which the exchange rate increases linearly over. This is to prevent gaming the exchange rate (MEV).
1069     The cycles are constant length, but calling syncRewards slightly into a would-be cycle keeps the same would-be endpoint (so cycle ends are every X seconds).
1070     Someone must call syncRewards, which queues any new frxETH in the contract to be added to the redeemable amount.
1071     sfrxETH adheres to ERC-4626 vault specs 
1072     Mint vs Deposit
1073     mint() - deposit targeting a specific number of sfrxETH out
1074     deposit() - deposit knowing a specific number of frxETH in */
1075 contract sfrxETH is xERC4626, ReentrancyGuard {
1076 
1077     modifier andSync {
1078         if (block.timestamp >= rewardsCycleEnd) { syncRewards(); } 
1079         _;
1080     }
1081 
1082     /* ========== CONSTRUCTOR ========== */
1083     constructor(ERC20 _underlying, uint32 _rewardsCycleLength)
1084         ERC4626(_underlying, "Staked Frax Ether", "sfrxETH")
1085         xERC4626(_rewardsCycleLength)
1086     {}
1087 
1088     /// @notice inlines syncRewards with deposits when able
1089     function deposit(uint256 assets, address receiver) public override andSync returns (uint256 shares) {
1090         return super.deposit(assets, receiver);
1091     }
1092     
1093     /// @notice inlines syncRewards with mints when able
1094     function mint(uint256 shares, address receiver) public override andSync returns (uint256 assets) {
1095         return super.mint(shares, receiver);
1096     }
1097 
1098     /// @notice inlines syncRewards with withdrawals when able
1099     function withdraw(
1100         uint256 assets,
1101         address receiver,
1102         address owner
1103     ) public override andSync returns (uint256 shares) {
1104         return super.withdraw(assets, receiver, owner);
1105     }
1106 
1107     /// @notice inlines syncRewards with redemptions when able
1108     function redeem(
1109         uint256 shares,
1110         address receiver,
1111         address owner
1112     ) public override andSync returns (uint256 assets) {
1113         return super.redeem(shares, receiver, owner);
1114     }
1115 
1116     /// @notice How much frxETH is 1E18 sfrxETH worth. Price is in ETH, not USD
1117     function pricePerShare() public view returns (uint256) {
1118         return convertToAssets(1e18);
1119     }
1120 
1121     /// @notice Approve and deposit() in one transaction
1122     function depositWithSignature(
1123         uint256 assets,
1124         address receiver,
1125         uint256 deadline,
1126         bool approveMax,
1127         uint8 v,
1128         bytes32 r,
1129         bytes32 s
1130     ) external nonReentrant returns (uint256 shares) {
1131         uint256 amount = approveMax ? type(uint256).max : assets;
1132         asset.permit(msg.sender, address(this), amount, deadline, v, r, s);
1133         return (deposit(assets, receiver));
1134     }
1135 
1136 }