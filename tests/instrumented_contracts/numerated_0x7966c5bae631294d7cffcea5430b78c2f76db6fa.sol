1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
5 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
6 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
7 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
8 abstract contract ERC20 {
9     /*//////////////////////////////////////////////////////////////
10                                  EVENTS
11     //////////////////////////////////////////////////////////////*/
12 
13     event Transfer(address indexed from, address indexed to, uint256 amount);
14 
15     event Approval(address indexed owner, address indexed spender, uint256 amount);
16 
17     /*//////////////////////////////////////////////////////////////
18                             METADATA STORAGE
19     //////////////////////////////////////////////////////////////*/
20 
21     string public name;
22 
23     string public symbol;
24 
25     uint8 public immutable decimals;
26 
27     /*//////////////////////////////////////////////////////////////
28                               ERC20 STORAGE
29     //////////////////////////////////////////////////////////////*/
30 
31     uint256 public totalSupply;
32 
33     mapping(address => uint256) public balanceOf;
34 
35     mapping(address => mapping(address => uint256)) public allowance;
36 
37     /*//////////////////////////////////////////////////////////////
38                             EIP-2612 STORAGE
39     //////////////////////////////////////////////////////////////*/
40 
41     uint256 internal immutable INITIAL_CHAIN_ID;
42 
43     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
44 
45     mapping(address => uint256) public nonces;
46 
47     /*//////////////////////////////////////////////////////////////
48                                CONSTRUCTOR
49     //////////////////////////////////////////////////////////////*/
50 
51     constructor(
52         string memory _name,
53         string memory _symbol,
54         uint8 _decimals
55     ) {
56         name = _name;
57         symbol = _symbol;
58         decimals = _decimals;
59 
60         INITIAL_CHAIN_ID = block.chainid;
61         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
62     }
63 
64     /*//////////////////////////////////////////////////////////////
65                                ERC20 LOGIC
66     //////////////////////////////////////////////////////////////*/
67 
68     function approve(address spender, uint256 amount) public virtual returns (bool) {
69         allowance[msg.sender][spender] = amount;
70 
71         emit Approval(msg.sender, spender, amount);
72 
73         return true;
74     }
75 
76     function transfer(address to, uint256 amount) public virtual returns (bool) {
77         balanceOf[msg.sender] -= amount;
78 
79         // Cannot overflow because the sum of all user
80         // balances can't exceed the max uint256 value.
81         unchecked {
82             balanceOf[to] += amount;
83         }
84 
85         emit Transfer(msg.sender, to, amount);
86 
87         return true;
88     }
89 
90     function transferFrom(
91         address from,
92         address to,
93         uint256 amount
94     ) public virtual returns (bool) {
95         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
96 
97         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
98 
99         balanceOf[from] -= amount;
100 
101         // Cannot overflow because the sum of all user
102         // balances can't exceed the max uint256 value.
103         unchecked {
104             balanceOf[to] += amount;
105         }
106 
107         emit Transfer(from, to, amount);
108 
109         return true;
110     }
111 
112     /*//////////////////////////////////////////////////////////////
113                              EIP-2612 LOGIC
114     //////////////////////////////////////////////////////////////*/
115 
116     function permit(
117         address owner,
118         address spender,
119         uint256 value,
120         uint256 deadline,
121         uint8 v,
122         bytes32 r,
123         bytes32 s
124     ) public virtual {
125         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
126 
127         // Unchecked because the only math done is incrementing
128         // the owner's nonce which cannot realistically overflow.
129         unchecked {
130             address recoveredAddress = ecrecover(
131                 keccak256(
132                     abi.encodePacked(
133                         "\x19\x01",
134                         DOMAIN_SEPARATOR(),
135                         keccak256(
136                             abi.encode(
137                                 keccak256(
138                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
139                                 ),
140                                 owner,
141                                 spender,
142                                 value,
143                                 nonces[owner]++,
144                                 deadline
145                             )
146                         )
147                     )
148                 ),
149                 v,
150                 r,
151                 s
152             );
153 
154             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
155 
156             allowance[recoveredAddress][spender] = value;
157         }
158 
159         emit Approval(owner, spender, value);
160     }
161 
162     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
163         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
164     }
165 
166     function computeDomainSeparator() internal view virtual returns (bytes32) {
167         return
168             keccak256(
169                 abi.encode(
170                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
171                     keccak256(bytes(name)),
172                     keccak256("1"),
173                     block.chainid,
174                     address(this)
175                 )
176             );
177     }
178 
179     /*//////////////////////////////////////////////////////////////
180                         INTERNAL MINT/BURN LOGIC
181     //////////////////////////////////////////////////////////////*/
182 
183     function _mint(address to, uint256 amount) internal virtual {
184         totalSupply += amount;
185 
186         // Cannot overflow because the sum of all user
187         // balances can't exceed the max uint256 value.
188         unchecked {
189             balanceOf[to] += amount;
190         }
191 
192         emit Transfer(address(0), to, amount);
193     }
194 
195     function _burn(address from, uint256 amount) internal virtual {
196         balanceOf[from] -= amount;
197 
198         // Cannot underflow because a user's balance
199         // will never be larger than the total supply.
200         unchecked {
201             totalSupply -= amount;
202         }
203 
204         emit Transfer(from, address(0), amount);
205     }
206 }
207 
208 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
209 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
210 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
211 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
212 library SafeTransferLib {
213     /*//////////////////////////////////////////////////////////////
214                              ETH OPERATIONS
215     //////////////////////////////////////////////////////////////*/
216 
217     function safeTransferETH(address to, uint256 amount) internal {
218         bool success;
219 
220         /// @solidity memory-safe-assembly
221         assembly {
222             // Transfer the ETH and store if it succeeded or not.
223             success := call(gas(), to, amount, 0, 0, 0, 0)
224         }
225 
226         require(success, "ETH_TRANSFER_FAILED");
227     }
228 
229     /*//////////////////////////////////////////////////////////////
230                             ERC20 OPERATIONS
231     //////////////////////////////////////////////////////////////*/
232 
233     function safeTransferFrom(
234         ERC20 token,
235         address from,
236         address to,
237         uint256 amount
238     ) internal {
239         bool success;
240 
241         /// @solidity memory-safe-assembly
242         assembly {
243             // Get a pointer to some free memory.
244             let freeMemoryPointer := mload(0x40)
245 
246             // Write the abi-encoded calldata into memory, beginning with the function selector.
247             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
248             mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
249             mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
250             mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
251 
252             success := and(
253                 // Set success to whether the call reverted, if not we check it either
254                 // returned exactly 1 (can't just be non-zero data), or had no return data.
255                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
256                 // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
257                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
258                 // Counterintuitively, this call must be positioned second to the or() call in the
259                 // surrounding and() call or else returndatasize() will be zero during the computation.
260                 call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
261             )
262         }
263 
264         require(success, "TRANSFER_FROM_FAILED");
265     }
266 
267     function safeTransfer(
268         ERC20 token,
269         address to,
270         uint256 amount
271     ) internal {
272         bool success;
273 
274         /// @solidity memory-safe-assembly
275         assembly {
276             // Get a pointer to some free memory.
277             let freeMemoryPointer := mload(0x40)
278 
279             // Write the abi-encoded calldata into memory, beginning with the function selector.
280             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
281             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
282             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
283 
284             success := and(
285                 // Set success to whether the call reverted, if not we check it either
286                 // returned exactly 1 (can't just be non-zero data), or had no return data.
287                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
288                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
289                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
290                 // Counterintuitively, this call must be positioned second to the or() call in the
291                 // surrounding and() call or else returndatasize() will be zero during the computation.
292                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
293             )
294         }
295 
296         require(success, "TRANSFER_FAILED");
297     }
298 
299     function safeApprove(
300         ERC20 token,
301         address to,
302         uint256 amount
303     ) internal {
304         bool success;
305 
306         /// @solidity memory-safe-assembly
307         assembly {
308             // Get a pointer to some free memory.
309             let freeMemoryPointer := mload(0x40)
310 
311             // Write the abi-encoded calldata into memory, beginning with the function selector.
312             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
313             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
314             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
315 
316             success := and(
317                 // Set success to whether the call reverted, if not we check it either
318                 // returned exactly 1 (can't just be non-zero data), or had no return data.
319                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
320                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
321                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
322                 // Counterintuitively, this call must be positioned second to the or() call in the
323                 // surrounding and() call or else returndatasize() will be zero during the computation.
324                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
325             )
326         }
327 
328         require(success, "APPROVE_FAILED");
329     }
330 }
331 
332 /// @notice Arithmetic library with operations for fixed-point numbers.
333 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
334 /// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
335 library FixedPointMathLib {
336     /*//////////////////////////////////////////////////////////////
337                     SIMPLIFIED FIXED POINT OPERATIONS
338     //////////////////////////////////////////////////////////////*/
339 
340     uint256 internal constant MAX_UINT256 = 2**256 - 1;
341 
342     uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.
343 
344     function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
345         return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
346     }
347 
348     function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
349         return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
350     }
351 
352     function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
353         return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
354     }
355 
356     function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
357         return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
358     }
359 
360     /*//////////////////////////////////////////////////////////////
361                     LOW LEVEL FIXED POINT OPERATIONS
362     //////////////////////////////////////////////////////////////*/
363 
364     function mulDivDown(
365         uint256 x,
366         uint256 y,
367         uint256 denominator
368     ) internal pure returns (uint256 z) {
369         /// @solidity memory-safe-assembly
370         assembly {
371             // Equivalent to require(denominator != 0 && (y == 0 || x <= type(uint256).max / y))
372             if iszero(mul(denominator, iszero(mul(y, gt(x, div(MAX_UINT256, y)))))) {
373                 revert(0, 0)
374             }
375 
376             // Divide x * y by the denominator.
377             z := div(mul(x, y), denominator)
378         }
379     }
380 
381     function mulDivUp(
382         uint256 x,
383         uint256 y,
384         uint256 denominator
385     ) internal pure returns (uint256 z) {
386         /// @solidity memory-safe-assembly
387         assembly {
388             // Equivalent to require(denominator != 0 && (y == 0 || x <= type(uint256).max / y))
389             if iszero(mul(denominator, iszero(mul(y, gt(x, div(MAX_UINT256, y)))))) {
390                 revert(0, 0)
391             }
392 
393             // If x * y modulo the denominator is strictly greater than 0,
394             // 1 is added to round up the division of x * y by the denominator.
395             z := add(gt(mod(mul(x, y), denominator), 0), div(mul(x, y), denominator))
396         }
397     }
398 
399     function rpow(
400         uint256 x,
401         uint256 n,
402         uint256 scalar
403     ) internal pure returns (uint256 z) {
404         /// @solidity memory-safe-assembly
405         assembly {
406             switch x
407             case 0 {
408                 switch n
409                 case 0 {
410                     // 0 ** 0 = 1
411                     z := scalar
412                 }
413                 default {
414                     // 0 ** n = 0
415                     z := 0
416                 }
417             }
418             default {
419                 switch mod(n, 2)
420                 case 0 {
421                     // If n is even, store scalar in z for now.
422                     z := scalar
423                 }
424                 default {
425                     // If n is odd, store x in z for now.
426                     z := x
427                 }
428 
429                 // Shifting right by 1 is like dividing by 2.
430                 let half := shr(1, scalar)
431 
432                 for {
433                     // Shift n right by 1 before looping to halve it.
434                     n := shr(1, n)
435                 } n {
436                     // Shift n right by 1 each iteration to halve it.
437                     n := shr(1, n)
438                 } {
439                     // Revert immediately if x ** 2 would overflow.
440                     // Equivalent to iszero(eq(div(xx, x), x)) here.
441                     if shr(128, x) {
442                         revert(0, 0)
443                     }
444 
445                     // Store x squared.
446                     let xx := mul(x, x)
447 
448                     // Round to the nearest number.
449                     let xxRound := add(xx, half)
450 
451                     // Revert if xx + half overflowed.
452                     if lt(xxRound, xx) {
453                         revert(0, 0)
454                     }
455 
456                     // Set x to scaled xxRound.
457                     x := div(xxRound, scalar)
458 
459                     // If n is even:
460                     if mod(n, 2) {
461                         // Compute z * x.
462                         let zx := mul(z, x)
463 
464                         // If z * x overflowed:
465                         if iszero(eq(div(zx, x), z)) {
466                             // Revert if x is non-zero.
467                             if iszero(iszero(x)) {
468                                 revert(0, 0)
469                             }
470                         }
471 
472                         // Round to the nearest number.
473                         let zxRound := add(zx, half)
474 
475                         // Revert if zx + half overflowed.
476                         if lt(zxRound, zx) {
477                             revert(0, 0)
478                         }
479 
480                         // Return properly scaled zxRound.
481                         z := div(zxRound, scalar)
482                     }
483                 }
484             }
485         }
486     }
487 
488     /*//////////////////////////////////////////////////////////////
489                         GENERAL NUMBER UTILITIES
490     //////////////////////////////////////////////////////////////*/
491 
492     function sqrt(uint256 x) internal pure returns (uint256 z) {
493         /// @solidity memory-safe-assembly
494         assembly {
495             let y := x // We start y at x, which will help us make our initial estimate.
496 
497             z := 181 // The "correct" value is 1, but this saves a multiplication later.
498 
499             // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
500             // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.
501 
502             // We check y >= 2^(k + 8) but shift right by k bits
503             // each branch to ensure that if x >= 256, then y >= 256.
504             if iszero(lt(y, 0x10000000000000000000000000000000000)) {
505                 y := shr(128, y)
506                 z := shl(64, z)
507             }
508             if iszero(lt(y, 0x1000000000000000000)) {
509                 y := shr(64, y)
510                 z := shl(32, z)
511             }
512             if iszero(lt(y, 0x10000000000)) {
513                 y := shr(32, y)
514                 z := shl(16, z)
515             }
516             if iszero(lt(y, 0x1000000)) {
517                 y := shr(16, y)
518                 z := shl(8, z)
519             }
520 
521             // Goal was to get z*z*y within a small factor of x. More iterations could
522             // get y in a tighter range. Currently, we will have y in [256, 256*2^16).
523             // We ensured y >= 256 so that the relative difference between y and y+1 is small.
524             // That's not possible if x < 256 but we can just verify those cases exhaustively.
525 
526             // Now, z*z*y <= x < z*z*(y+1), and y <= 2^(16+8), and either y >= 256, or x < 256.
527             // Correctness can be checked exhaustively for x < 256, so we assume y >= 256.
528             // Then z*sqrt(y) is within sqrt(257)/sqrt(256) of sqrt(x), or about 20bps.
529 
530             // For s in the range [1/256, 256], the estimate f(s) = (181/1024) * (s+1) is in the range
531             // (1/2.84 * sqrt(s), 2.84 * sqrt(s)), with largest error when s = 1 and when s = 256 or 1/256.
532 
533             // Since y is in [256, 256*2^16), let a = y/65536, so that a is in [1/256, 256). Then we can estimate
534             // sqrt(y) using sqrt(65536) * 181/1024 * (a + 1) = 181/4 * (y + 65536)/65536 = 181 * (y + 65536)/2^18.
535 
536             // There is no overflow risk here since y < 2^136 after the first branch above.
537             z := shr(18, mul(z, add(y, 65536))) // A mul() is saved from starting z at 181.
538 
539             // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
540             z := shr(1, add(z, div(x, z)))
541             z := shr(1, add(z, div(x, z)))
542             z := shr(1, add(z, div(x, z)))
543             z := shr(1, add(z, div(x, z)))
544             z := shr(1, add(z, div(x, z)))
545             z := shr(1, add(z, div(x, z)))
546             z := shr(1, add(z, div(x, z)))
547 
548             // If x+1 is a perfect square, the Babylonian method cycles between
549             // floor(sqrt(x)) and ceil(sqrt(x)). This statement ensures we return floor.
550             // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
551             // Since the ceil is rare, we save gas on the assignment and repeat division in the rare case.
552             // If you don't care whether the floor or ceil square root is returned, you can remove this statement.
553             z := sub(z, lt(div(x, z), z))
554         }
555     }
556 
557     function unsafeMod(uint256 x, uint256 y) internal pure returns (uint256 z) {
558         /// @solidity memory-safe-assembly
559         assembly {
560             // Mod x by y. Note this will return
561             // 0 instead of reverting if y is zero.
562             z := mod(x, y)
563         }
564     }
565 
566     function unsafeDiv(uint256 x, uint256 y) internal pure returns (uint256 r) {
567         /// @solidity memory-safe-assembly
568         assembly {
569             // Divide x by y. Note this will return
570             // 0 instead of reverting if y is zero.
571             r := div(x, y)
572         }
573     }
574 
575     function unsafeDivUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
576         /// @solidity memory-safe-assembly
577         assembly {
578             // Add 1 to x * y if x % y > 0. Note this will
579             // return 0 instead of reverting if y is zero.
580             z := add(gt(mod(x, y), 0), div(x, y))
581         }
582     }
583 }
584 
585 /// @notice Minimal ERC4626 tokenized Vault implementation.
586 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/mixins/ERC4626.sol)
587 abstract contract ERC4626 is ERC20 {
588     using SafeTransferLib for ERC20;
589     using FixedPointMathLib for uint256;
590 
591     /*//////////////////////////////////////////////////////////////
592                                  EVENTS
593     //////////////////////////////////////////////////////////////*/
594 
595     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
596 
597     event Withdraw(
598         address indexed caller,
599         address indexed receiver,
600         address indexed owner,
601         uint256 assets,
602         uint256 shares
603     );
604 
605     /*//////////////////////////////////////////////////////////////
606                                IMMUTABLES
607     //////////////////////////////////////////////////////////////*/
608 
609     ERC20 public immutable asset;
610 
611     constructor(
612         ERC20 _asset,
613         string memory _name,
614         string memory _symbol
615     ) ERC20(_name, _symbol, _asset.decimals()) {
616         asset = _asset;
617     }
618 
619     /*//////////////////////////////////////////////////////////////
620                         DEPOSIT/WITHDRAWAL LOGIC
621     //////////////////////////////////////////////////////////////*/
622 
623     function deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
624         // Check for rounding error since we round down in previewDeposit.
625         require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");
626 
627         // Need to transfer before minting or ERC777s could reenter.
628         asset.safeTransferFrom(msg.sender, address(this), assets);
629 
630         _mint(receiver, shares);
631 
632         emit Deposit(msg.sender, receiver, assets, shares);
633 
634         afterDeposit(assets, shares);
635     }
636 
637     function mint(uint256 shares, address receiver) public virtual returns (uint256 assets) {
638         assets = previewMint(shares); // No need to check for rounding error, previewMint rounds up.
639 
640         // Need to transfer before minting or ERC777s could reenter.
641         asset.safeTransferFrom(msg.sender, address(this), assets);
642 
643         _mint(receiver, shares);
644 
645         emit Deposit(msg.sender, receiver, assets, shares);
646 
647         afterDeposit(assets, shares);
648     }
649 
650     function withdraw(
651         uint256 assets,
652         address receiver,
653         address owner
654     ) public virtual returns (uint256 shares) {
655         shares = previewWithdraw(assets); // No need to check for rounding error, previewWithdraw rounds up.
656 
657         if (msg.sender != owner) {
658             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
659 
660             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
661         }
662 
663         beforeWithdraw(assets, shares);
664 
665         _burn(owner, shares);
666 
667         emit Withdraw(msg.sender, receiver, owner, assets, shares);
668 
669         asset.safeTransfer(receiver, assets);
670     }
671 
672     function redeem(
673         uint256 shares,
674         address receiver,
675         address owner
676     ) public virtual returns (uint256 assets) {
677         if (msg.sender != owner) {
678             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
679 
680             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
681         }
682 
683         // Check for rounding error since we round down in previewRedeem.
684         require((assets = previewRedeem(shares)) != 0, "ZERO_ASSETS");
685 
686         beforeWithdraw(assets, shares);
687 
688         _burn(owner, shares);
689 
690         emit Withdraw(msg.sender, receiver, owner, assets, shares);
691 
692         asset.safeTransfer(receiver, assets);
693     }
694 
695     /*//////////////////////////////////////////////////////////////
696                             ACCOUNTING LOGIC
697     //////////////////////////////////////////////////////////////*/
698 
699     function totalAssets() public view virtual returns (uint256);
700 
701     function convertToShares(uint256 assets) public view virtual returns (uint256) {
702         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
703 
704         return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
705     }
706 
707     function convertToAssets(uint256 shares) public view virtual returns (uint256) {
708         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
709 
710         return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
711     }
712 
713     function previewDeposit(uint256 assets) public view virtual returns (uint256) {
714         return convertToShares(assets);
715     }
716 
717     function previewMint(uint256 shares) public view virtual returns (uint256) {
718         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
719 
720         return supply == 0 ? shares : shares.mulDivUp(totalAssets(), supply);
721     }
722 
723     function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
724         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
725 
726         return supply == 0 ? assets : assets.mulDivUp(supply, totalAssets());
727     }
728 
729     function previewRedeem(uint256 shares) public view virtual returns (uint256) {
730         return convertToAssets(shares);
731     }
732 
733     /*//////////////////////////////////////////////////////////////
734                      DEPOSIT/WITHDRAWAL LIMIT LOGIC
735     //////////////////////////////////////////////////////////////*/
736 
737     function maxDeposit(address) public view virtual returns (uint256) {
738         return type(uint256).max;
739     }
740 
741     function maxMint(address) public view virtual returns (uint256) {
742         return type(uint256).max;
743     }
744 
745     function maxWithdraw(address owner) public view virtual returns (uint256) {
746         return convertToAssets(balanceOf[owner]);
747     }
748 
749     function maxRedeem(address owner) public view virtual returns (uint256) {
750         return balanceOf[owner];
751     }
752 
753     /*//////////////////////////////////////////////////////////////
754                           INTERNAL HOOKS LOGIC
755     //////////////////////////////////////////////////////////////*/
756 
757     function beforeWithdraw(uint256 assets, uint256 shares) internal virtual {}
758 
759     function afterDeposit(uint256 assets, uint256 shares) internal virtual {}
760 }
761 
762 /// @notice Simple single owner authorization mixin.
763 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
764 abstract contract Owned {
765     /*//////////////////////////////////////////////////////////////
766                                  EVENTS
767     //////////////////////////////////////////////////////////////*/
768 
769     event OwnershipTransferred(address indexed user, address indexed newOwner);
770 
771     /*//////////////////////////////////////////////////////////////
772                             OWNERSHIP STORAGE
773     //////////////////////////////////////////////////////////////*/
774 
775     address public owner;
776 
777     modifier onlyOwner() virtual {
778         require(msg.sender == owner, "UNAUTHORIZED");
779 
780         _;
781     }
782 
783     /*//////////////////////////////////////////////////////////////
784                                CONSTRUCTOR
785     //////////////////////////////////////////////////////////////*/
786 
787     constructor(address _owner) {
788         owner = _owner;
789 
790         emit OwnershipTransferred(address(0), _owner);
791     }
792 
793     /*//////////////////////////////////////////////////////////////
794                              OWNERSHIP LOGIC
795     //////////////////////////////////////////////////////////////*/
796 
797     function transferOwnership(address newOwner) public virtual onlyOwner {
798         owner = newOwner;
799 
800         emit OwnershipTransferred(msg.sender, newOwner);
801     }
802 }
803 
804 interface IStaking {
805     struct SingleNft {
806         uint32 tokenId;
807         uint224 amount;
808     }
809     struct PairNftDepositWithAmount {
810         uint32 mainTokenId;
811         uint32 bakcTokenId;
812         uint184 amount;
813     }
814     struct PairNftWithdrawWithAmount {
815         uint32 mainTokenId;
816         uint32 bakcTokenId;
817         uint184 amount;
818         bool isUncommit;
819     }
820     // ApeCoin logic
821     function depositSelfApeCoin(uint256 _amount) external;
822     function withdrawSelfApeCoin(uint256 _amount) external;
823     function claimSelfApeCoin() external;
824     // BAYC logic
825     function depositBAYC(SingleNft[] memory _nfts) external;
826     function claimSelfBAYC(uint256[] memory _nfts) external;
827     function withdrawBAYC(SingleNft[] memory _nfts, address _recipient) external;
828     // MAYC logic
829     function depositMAYC(SingleNft[] memory _nfts) external;
830     function claimSelfMAYC(uint256[] memory _nfts) external;
831     function withdrawMAYC(SingleNft[] memory _nfts, address _recipient) external;
832     // BAKC logic
833     function depositBAKC(PairNftDepositWithAmount[] calldata _baycPairs, PairNftDepositWithAmount[] calldata _maycPairs) external;
834     function withdrawBAKC(PairNftWithdrawWithAmount[] calldata _baycPairs, PairNftWithdrawWithAmount[] calldata _maycPairs) external;
835     function nftPosition(uint256 _poolId, uint256 _tokenId) external view returns (uint256, uint256);
836     function stakedTotal(address _address) external view returns (uint256);
837     function pendingRewards(uint256 _poolId, address _address, uint256 _tokenId) external view returns (uint256);
838 }
839 
840 contract StakedApe is ERC4626, Owned {
841     using SafeTransferLib for ERC20;
842 
843     event Harvest(uint256 amount, uint256 fees);
844     event Stake();
845 
846     IStaking public immutable staking;
847     uint256 public constant FEE = 200; // 2% fee
848 
849     constructor(address _apecoin, address _staking) ERC4626(ERC20(_apecoin), "Staked Apecoin", "sAPE") Owned(msg.sender){
850         staking = IStaking(_staking);
851         asset.approve(_staking, type(uint256).max);
852     }
853 
854     /// @notice the total balance of ApeCoin staked in the contract
855     function totalAssets() public view override returns (uint256) {
856         uint256 balance = asset.balanceOf(address(this));
857         uint256 staked = staking.stakedTotal(address(this));
858         uint256 pending = staking.pendingRewards(0, address(this), 0);
859         uint256 fees = pending * FEE / 10000;
860         return balance + staked + pending - fees;
861     }
862 
863     function afterDeposit(uint256, uint256) internal override {
864         // lets stake
865         harvest();
866     }
867 
868     function beforeWithdraw(uint256 assets, uint256) internal override {
869         // lets stake what we can
870         harvest();
871         // lets withdraw what we need
872         staking.withdrawSelfApeCoin(assets);
873     }
874 
875     /// @notice claim any pending rewards and stake them
876     function harvest() public {
877         // lets calc our fee
878         uint256 pending = staking.pendingRewards(0, address(this), 0);
879         uint256 fees = pending * FEE / 10000;
880         // claim rewards
881         staking.claimSelfApeCoin();
882         // take fee
883         asset.safeTransfer(owner, fees);
884         // try to deposit
885         if (asset.balanceOf(address(this)) > 1e18) {
886             staking.depositSelfApeCoin(asset.balanceOf(address(this)));
887         }
888 
889         emit Harvest(pending, fees);
890     }
891 }