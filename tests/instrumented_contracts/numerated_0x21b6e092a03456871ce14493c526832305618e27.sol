1 // SPDX-License-Identifier: AGPL-3.0
2 pragma solidity ^0.8.4;
3 
4 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
5 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
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
209 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
210 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
211 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
212 library SafeTransferLib {
213     event Debug(bool one, bool two, uint256 retsize);
214 
215     /*//////////////////////////////////////////////////////////////
216                              ETH OPERATIONS
217     //////////////////////////////////////////////////////////////*/
218 
219     function safeTransferETH(address to, uint256 amount) internal {
220         bool success;
221 
222         assembly {
223             // Transfer the ETH and store if it succeeded or not.
224             success := call(gas(), to, amount, 0, 0, 0, 0)
225         }
226 
227         require(success, "ETH_TRANSFER_FAILED");
228     }
229 
230     /*//////////////////////////////////////////////////////////////
231                             ERC20 OPERATIONS
232     //////////////////////////////////////////////////////////////*/
233 
234     function safeTransferFrom(
235         ERC20 token,
236         address from,
237         address to,
238         uint256 amount
239     ) internal {
240         bool success;
241 
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
274         assembly {
275             // Get a pointer to some free memory.
276             let freeMemoryPointer := mload(0x40)
277 
278             // Write the abi-encoded calldata into memory, beginning with the function selector.
279             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
280             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
281             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
282 
283             success := and(
284                 // Set success to whether the call reverted, if not we check it either
285                 // returned exactly 1 (can't just be non-zero data), or had no return data.
286                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
287                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
288                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
289                 // Counterintuitively, this call must be positioned second to the or() call in the
290                 // surrounding and() call or else returndatasize() will be zero during the computation.
291                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
292             )
293         }
294 
295         require(success, "TRANSFER_FAILED");
296     }
297 
298     function safeApprove(
299         ERC20 token,
300         address to,
301         uint256 amount
302     ) internal {
303         bool success;
304 
305         assembly {
306             // Get a pointer to some free memory.
307             let freeMemoryPointer := mload(0x40)
308 
309             // Write the abi-encoded calldata into memory, beginning with the function selector.
310             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
311             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
312             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
313 
314             success := and(
315                 // Set success to whether the call reverted, if not we check it either
316                 // returned exactly 1 (can't just be non-zero data), or had no return data.
317                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
318                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
319                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
320                 // Counterintuitively, this call must be positioned second to the or() call in the
321                 // surrounding and() call or else returndatasize() will be zero during the computation.
322                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
323             )
324         }
325 
326         require(success, "APPROVE_FAILED");
327     }
328 }
329 
330 /// @notice Minimalist and modern Wrapped Ether implementation.
331 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/WETH.sol)
332 /// @author Inspired by WETH9 (https://github.com/dapphub/ds-weth/blob/master/src/weth9.sol)
333 contract WETH is ERC20("Wrapped Ether", "WETH", 18) {
334     using SafeTransferLib for address;
335 
336     event Deposit(address indexed from, uint256 amount);
337 
338     event Withdrawal(address indexed to, uint256 amount);
339 
340     function deposit() public payable virtual {
341         _mint(msg.sender, msg.value);
342 
343         emit Deposit(msg.sender, msg.value);
344     }
345 
346     function withdraw(uint256 amount) public virtual {
347         _burn(msg.sender, amount);
348 
349         emit Withdrawal(msg.sender, amount);
350 
351         msg.sender.safeTransferETH(amount);
352     }
353 
354     receive() external payable virtual {
355         deposit();
356     }
357 }
358 
359 /// @notice Arithmetic library with operations for fixed-point numbers.
360 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/FixedPointMathLib.sol)
361 /// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
362 library FixedPointMathLib {
363     /*//////////////////////////////////////////////////////////////
364                     SIMPLIFIED FIXED POINT OPERATIONS
365     //////////////////////////////////////////////////////////////*/
366 
367     uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.
368 
369     function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
370         return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
371     }
372 
373     function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
374         return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
375     }
376 
377     function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
378         return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
379     }
380 
381     function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
382         return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
383     }
384 
385     /*//////////////////////////////////////////////////////////////
386                     LOW LEVEL FIXED POINT OPERATIONS
387     //////////////////////////////////////////////////////////////*/
388 
389     function mulDivDown(
390         uint256 x,
391         uint256 y,
392         uint256 denominator
393     ) internal pure returns (uint256 z) {
394         assembly {
395             // Store x * y in z for now.
396             z := mul(x, y)
397 
398             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
399             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
400                 revert(0, 0)
401             }
402 
403             // Divide z by the denominator.
404             z := div(z, denominator)
405         }
406     }
407 
408     function mulDivUp(
409         uint256 x,
410         uint256 y,
411         uint256 denominator
412     ) internal pure returns (uint256 z) {
413         assembly {
414             // Store x * y in z for now.
415             z := mul(x, y)
416 
417             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
418             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
419                 revert(0, 0)
420             }
421 
422             // First, divide z - 1 by the denominator and add 1.
423             // We allow z - 1 to underflow if z is 0, because we multiply the
424             // end result by 0 if z is zero, ensuring we return 0 if z is zero.
425             z := mul(iszero(iszero(z)), add(div(sub(z, 1), denominator), 1))
426         }
427     }
428 
429     function rpow(
430         uint256 x,
431         uint256 n,
432         uint256 scalar
433     ) internal pure returns (uint256 z) {
434         assembly {
435             switch x
436             case 0 {
437                 switch n
438                 case 0 {
439                     // 0 ** 0 = 1
440                     z := scalar
441                 }
442                 default {
443                     // 0 ** n = 0
444                     z := 0
445                 }
446             }
447             default {
448                 switch mod(n, 2)
449                 case 0 {
450                     // If n is even, store scalar in z for now.
451                     z := scalar
452                 }
453                 default {
454                     // If n is odd, store x in z for now.
455                     z := x
456                 }
457 
458                 // Shifting right by 1 is like dividing by 2.
459                 let half := shr(1, scalar)
460 
461                 for {
462                     // Shift n right by 1 before looping to halve it.
463                     n := shr(1, n)
464                 } n {
465                     // Shift n right by 1 each iteration to halve it.
466                     n := shr(1, n)
467                 } {
468                     // Revert immediately if x ** 2 would overflow.
469                     // Equivalent to iszero(eq(div(xx, x), x)) here.
470                     if shr(128, x) {
471                         revert(0, 0)
472                     }
473 
474                     // Store x squared.
475                     let xx := mul(x, x)
476 
477                     // Round to the nearest number.
478                     let xxRound := add(xx, half)
479 
480                     // Revert if xx + half overflowed.
481                     if lt(xxRound, xx) {
482                         revert(0, 0)
483                     }
484 
485                     // Set x to scaled xxRound.
486                     x := div(xxRound, scalar)
487 
488                     // If n is even:
489                     if mod(n, 2) {
490                         // Compute z * x.
491                         let zx := mul(z, x)
492 
493                         // If z * x overflowed:
494                         if iszero(eq(div(zx, x), z)) {
495                             // Revert if x is non-zero.
496                             if iszero(iszero(x)) {
497                                 revert(0, 0)
498                             }
499                         }
500 
501                         // Round to the nearest number.
502                         let zxRound := add(zx, half)
503 
504                         // Revert if zx + half overflowed.
505                         if lt(zxRound, zx) {
506                             revert(0, 0)
507                         }
508 
509                         // Return properly scaled zxRound.
510                         z := div(zxRound, scalar)
511                     }
512                 }
513             }
514         }
515     }
516 
517     /*//////////////////////////////////////////////////////////////
518                         GENERAL NUMBER UTILITIES
519     //////////////////////////////////////////////////////////////*/
520 
521     function sqrt(uint256 x) internal pure returns (uint256 z) {
522         assembly {
523             // Start off with z at 1.
524             z := 1
525 
526             // Used below to help find a nearby power of 2.
527             let y := x
528 
529             // Find the lowest power of 2 that is at least sqrt(x).
530             if iszero(lt(y, 0x100000000000000000000000000000000)) {
531                 y := shr(128, y) // Like dividing by 2 ** 128.
532                 z := shl(64, z) // Like multiplying by 2 ** 64.
533             }
534             if iszero(lt(y, 0x10000000000000000)) {
535                 y := shr(64, y) // Like dividing by 2 ** 64.
536                 z := shl(32, z) // Like multiplying by 2 ** 32.
537             }
538             if iszero(lt(y, 0x100000000)) {
539                 y := shr(32, y) // Like dividing by 2 ** 32.
540                 z := shl(16, z) // Like multiplying by 2 ** 16.
541             }
542             if iszero(lt(y, 0x10000)) {
543                 y := shr(16, y) // Like dividing by 2 ** 16.
544                 z := shl(8, z) // Like multiplying by 2 ** 8.
545             }
546             if iszero(lt(y, 0x100)) {
547                 y := shr(8, y) // Like dividing by 2 ** 8.
548                 z := shl(4, z) // Like multiplying by 2 ** 4.
549             }
550             if iszero(lt(y, 0x10)) {
551                 y := shr(4, y) // Like dividing by 2 ** 4.
552                 z := shl(2, z) // Like multiplying by 2 ** 2.
553             }
554             if iszero(lt(y, 0x8)) {
555                 // Equivalent to 2 ** z.
556                 z := shl(1, z)
557             }
558 
559             // Shifting right by 1 is like dividing by 2.
560             z := shr(1, add(z, div(x, z)))
561             z := shr(1, add(z, div(x, z)))
562             z := shr(1, add(z, div(x, z)))
563             z := shr(1, add(z, div(x, z)))
564             z := shr(1, add(z, div(x, z)))
565             z := shr(1, add(z, div(x, z)))
566             z := shr(1, add(z, div(x, z)))
567 
568             // Compute a rounded down version of z.
569             let zRoundDown := div(x, z)
570 
571             // If zRoundDown is smaller, use it.
572             if lt(zRoundDown, z) {
573                 z := zRoundDown
574             }
575         }
576     }
577 }
578 
579 /// @notice Minimal ERC4626 tokenized Vault implementation.
580 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/mixins/ERC4626.sol)
581 abstract contract ERC4626 is ERC20 {
582     using SafeTransferLib for ERC20;
583     using FixedPointMathLib for uint256;
584 
585     /*//////////////////////////////////////////////////////////////
586                                  EVENTS
587     //////////////////////////////////////////////////////////////*/
588 
589     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
590 
591     event Withdraw(
592         address indexed caller,
593         address indexed receiver,
594         address indexed owner,
595         uint256 assets,
596         uint256 shares
597     );
598 
599     /*//////////////////////////////////////////////////////////////
600                                IMMUTABLES
601     //////////////////////////////////////////////////////////////*/
602 
603     ERC20 public immutable asset;
604 
605     constructor(
606         ERC20 _asset,
607         string memory _name,
608         string memory _symbol
609     ) ERC20(_name, _symbol, _asset.decimals()) {
610         asset = _asset;
611     }
612 
613     /*//////////////////////////////////////////////////////////////
614                         DEPOSIT/WITHDRAWAL LOGIC
615     //////////////////////////////////////////////////////////////*/
616 
617     function deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
618         // Check for rounding error since we round down in previewDeposit.
619         require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");
620 
621         // Need to transfer before minting or ERC777s could reenter.
622         asset.safeTransferFrom(msg.sender, address(this), assets);
623 
624         _mint(receiver, shares);
625 
626         emit Deposit(msg.sender, receiver, assets, shares);
627 
628         afterDeposit(assets, shares);
629     }
630 
631     function mint(uint256 shares, address receiver) public virtual returns (uint256 assets) {
632         assets = previewMint(shares); // No need to check for rounding error, previewMint rounds up.
633 
634         // Need to transfer before minting or ERC777s could reenter.
635         asset.safeTransferFrom(msg.sender, address(this), assets);
636 
637         _mint(receiver, shares);
638 
639         emit Deposit(msg.sender, receiver, assets, shares);
640 
641         afterDeposit(assets, shares);
642     }
643 
644     function withdraw(
645         uint256 assets,
646         address receiver,
647         address owner
648     ) public virtual returns (uint256 shares) {
649         shares = previewWithdraw(assets); // No need to check for rounding error, previewWithdraw rounds up.
650 
651         if (msg.sender != owner) {
652             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
653 
654             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
655         }
656 
657         beforeWithdraw(assets, shares);
658 
659         _burn(owner, shares);
660 
661         emit Withdraw(msg.sender, receiver, owner, assets, shares);
662 
663         asset.safeTransfer(receiver, assets);
664     }
665 
666     function redeem(
667         uint256 shares,
668         address receiver,
669         address owner
670     ) public virtual returns (uint256 assets) {
671         if (msg.sender != owner) {
672             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
673 
674             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
675         }
676 
677         // Check for rounding error since we round down in previewRedeem.
678         require((assets = previewRedeem(shares)) != 0, "ZERO_ASSETS");
679 
680         beforeWithdraw(assets, shares);
681 
682         _burn(owner, shares);
683 
684         emit Withdraw(msg.sender, receiver, owner, assets, shares);
685 
686         asset.safeTransfer(receiver, assets);
687     }
688 
689     /*//////////////////////////////////////////////////////////////
690                             ACCOUNTING LOGIC
691     //////////////////////////////////////////////////////////////*/
692 
693     function totalAssets() public view virtual returns (uint256);
694 
695     function convertToShares(uint256 assets) public view virtual returns (uint256) {
696         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
697 
698         return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
699     }
700 
701     function convertToAssets(uint256 shares) public view virtual returns (uint256) {
702         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
703 
704         return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
705     }
706 
707     function previewDeposit(uint256 assets) public view virtual returns (uint256) {
708         return convertToShares(assets);
709     }
710 
711     function previewMint(uint256 shares) public view virtual returns (uint256) {
712         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
713 
714         return supply == 0 ? shares : shares.mulDivUp(totalAssets(), supply);
715     }
716 
717     function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
718         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
719 
720         return supply == 0 ? assets : assets.mulDivUp(supply, totalAssets());
721     }
722 
723     function previewRedeem(uint256 shares) public view virtual returns (uint256) {
724         return convertToAssets(shares);
725     }
726 
727     /*//////////////////////////////////////////////////////////////
728                      DEPOSIT/WITHDRAWAL LIMIT LOGIC
729     //////////////////////////////////////////////////////////////*/
730 
731     function maxDeposit(address) public view virtual returns (uint256) {
732         return type(uint256).max;
733     }
734 
735     function maxMint(address) public view virtual returns (uint256) {
736         return type(uint256).max;
737     }
738 
739     function maxWithdraw(address owner) public view virtual returns (uint256) {
740         return convertToAssets(balanceOf[owner]);
741     }
742 
743     function maxRedeem(address owner) public view virtual returns (uint256) {
744         return balanceOf[owner];
745     }
746 
747     /*//////////////////////////////////////////////////////////////
748                           INTERNAL HOOKS LOGIC
749     //////////////////////////////////////////////////////////////*/
750 
751     function beforeWithdraw(uint256 assets, uint256 shares) internal virtual {}
752 
753     function afterDeposit(uint256 assets, uint256 shares) internal virtual {}
754 }
755 
756 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
757 // Simplified by BoringCrypto
758 
759 contract BoringOwnableData {
760     address public owner;
761     address public pendingOwner;
762 }
763 
764 contract BoringOwnable is BoringOwnableData {
765     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
766 
767     /// @notice `owner` defaults to msg.sender on construction.
768     constructor() {
769         owner = msg.sender;
770         emit OwnershipTransferred(address(0), msg.sender);
771     }
772 
773     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
774     /// Can only be invoked by the current `owner`.
775     /// @param newOwner Address of the new owner.
776     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
777     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
778     function transferOwnership(
779         address newOwner,
780         bool direct,
781         bool renounce
782     ) public onlyOwner {
783         if (direct) {
784             // Checks
785             require(newOwner != address(0) || renounce, "Ownable: zero address");
786 
787             // Effects
788             emit OwnershipTransferred(owner, newOwner);
789             owner = newOwner;
790             pendingOwner = address(0);
791         } else {
792             // Effects
793             pendingOwner = newOwner;
794         }
795     }
796 
797     /// @notice Needs to be called by `pendingOwner` to claim ownership.
798     function claimOwnership() public {
799         address _pendingOwner = pendingOwner;
800 
801         // Checks
802         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
803 
804         // Effects
805         emit OwnershipTransferred(owner, _pendingOwner);
806         owner = _pendingOwner;
807         pendingOwner = address(0);
808     }
809 
810     /// @notice Only allows the `owner` to execute the function.
811     modifier onlyOwner() {
812         require(msg.sender == owner, "Ownable: caller is not the owner");
813         _;
814     }
815 }
816 
817 /// @notice Gas optimized reentrancy protection for smart contracts.
818 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
819 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
820 abstract contract ReentrancyGuard {
821     uint256 private locked = 1;
822 
823     modifier nonReentrant() virtual {
824         require(locked == 1, "REENTRANCY");
825 
826         locked = 2;
827 
828         _;
829 
830         locked = 1;
831     }
832 }
833 
834 /// @notice Library for converting between addresses and bytes32 values.
835 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/Bytes32AddressLib.sol)
836 library Bytes32AddressLib {
837     function fromLast20Bytes(bytes32 bytesValue) internal pure returns (address) {
838         return address(uint160(uint256(bytesValue)));
839     }
840 
841     function fillLast12Bytes(address addressValue) internal pure returns (bytes32) {
842         return bytes32(bytes20(addressValue));
843     }
844 }
845 
846 /// @title BaseERC20
847 /// @author zefram.eth
848 /// @notice The base ERC20 contract used by NegativeYieldToken and PerpetualYieldToken
849 /// @dev Uses the same number of decimals as the vault's underlying token
850 contract BaseERC20 is ERC20 {
851     /// -----------------------------------------------------------------------
852     /// Errors
853     /// -----------------------------------------------------------------------
854 
855     error Error_NotGate();
856 
857     /// -----------------------------------------------------------------------
858     /// Immutable parameters
859     /// -----------------------------------------------------------------------
860 
861     Gate public immutable gate;
862     address public immutable vault;
863 
864     /// -----------------------------------------------------------------------
865     /// Constructor
866     /// -----------------------------------------------------------------------
867 
868     constructor(
869         string memory name_,
870         string memory symbol_,
871         Gate gate_,
872         address vault_
873     ) ERC20(name_, symbol_, gate_.getUnderlyingOfVault(vault_).decimals()) {
874         gate = gate_;
875         vault = vault_;
876     }
877 
878     /// -----------------------------------------------------------------------
879     /// Gate-callable functions
880     /// -----------------------------------------------------------------------
881 
882     function gateMint(address to, uint256 amount) external virtual {
883         if (msg.sender != address(gate)) {
884             revert Error_NotGate();
885         }
886 
887         _mint(to, amount);
888     }
889 
890     function gateBurn(address from, uint256 amount) external virtual {
891         if (msg.sender != address(gate)) {
892             revert Error_NotGate();
893         }
894 
895         _burn(from, amount);
896     }
897 }
898 
899 /// @title NegativeYieldToken
900 /// @author zefram.eth
901 /// @notice The ERC20 contract representing negative yield tokens
902 contract NegativeYieldToken is BaseERC20 {
903     /// -----------------------------------------------------------------------
904     /// Constructor
905     /// -----------------------------------------------------------------------
906 
907     constructor(Gate gate_, address vault_)
908         BaseERC20(
909             gate_.negativeYieldTokenName(vault_),
910             gate_.negativeYieldTokenSymbol(vault_),
911             gate_,
912             vault_
913         )
914     {}
915 }
916 
917 /// @title PerpetualYieldToken
918 /// @author zefram.eth
919 /// @notice The ERC20 contract representing perpetual yield tokens
920 contract PerpetualYieldToken is BaseERC20 {
921     /// -----------------------------------------------------------------------
922     /// Constructor
923     /// -----------------------------------------------------------------------
924 
925     constructor(Gate gate_, address vault_)
926         BaseERC20(
927             gate_.perpetualYieldTokenName(vault_),
928             gate_.perpetualYieldTokenSymbol(vault_),
929             gate_,
930             vault_
931         )
932     {}
933 
934     /// -----------------------------------------------------------------------
935     /// ERC20 overrides
936     /// -----------------------------------------------------------------------
937 
938     function transfer(address to, uint256 amount)
939         public
940         virtual
941         override
942         returns (bool)
943     {
944         // load balances to save gas
945         uint256 fromBalance = balanceOf[msg.sender];
946         uint256 toBalance = balanceOf[to];
947 
948         // call transfer hook
949         gate.beforePerpetualYieldTokenTransfer(
950             msg.sender,
951             to,
952             amount,
953             fromBalance,
954             toBalance
955         );
956 
957         // do transfer
958         // skip during self transfers since toBalance is cached
959         // which leads to free minting, a critical issue
960         if (msg.sender != to) {
961             balanceOf[msg.sender] = fromBalance - amount;
962 
963             // Cannot overflow because the sum of all user
964             // balances can't exceed the max uint256 value.
965             unchecked {
966                 balanceOf[to] = toBalance + amount;
967             }
968         }
969 
970         emit Transfer(msg.sender, to, amount);
971 
972         return true;
973     }
974 
975     function transferFrom(
976         address from,
977         address to,
978         uint256 amount
979     ) public virtual override returns (bool) {
980         // load balances to save gas
981         uint256 fromBalance = balanceOf[from];
982         uint256 toBalance = balanceOf[to];
983 
984         // call transfer hook
985         gate.beforePerpetualYieldTokenTransfer(
986             from,
987             to,
988             amount,
989             fromBalance,
990             toBalance
991         );
992 
993         // update allowance
994         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
995 
996         if (allowed != type(uint256).max)
997             allowance[from][msg.sender] = allowed - amount;
998 
999         // do transfer
1000         // skip during self transfers since toBalance is cached
1001         // which leads to free minting, a critical issue
1002         if (from != to) {
1003             balanceOf[from] = fromBalance - amount;
1004 
1005             // Cannot overflow because the sum of all user
1006             // balances can't exceed the max uint256 value.
1007             unchecked {
1008                 balanceOf[to] = toBalance + amount;
1009             }
1010         }
1011 
1012         emit Transfer(from, to, amount);
1013 
1014         return true;
1015     }
1016 }
1017 
1018 contract Factory is BoringOwnable {
1019     /// -----------------------------------------------------------------------
1020     /// Library usage
1021     /// -----------------------------------------------------------------------
1022 
1023     using Bytes32AddressLib for address;
1024     using Bytes32AddressLib for bytes32;
1025 
1026     /// -----------------------------------------------------------------------
1027     /// Errors
1028     /// -----------------------------------------------------------------------
1029 
1030     error Error_ProtocolFeeRecipientIsZero();
1031 
1032     /// -----------------------------------------------------------------------
1033     /// Events
1034     /// -----------------------------------------------------------------------
1035 
1036     event SetProtocolFee(ProtocolFeeInfo protocolFeeInfo_);
1037     event DeployYieldTokenPair(
1038         Gate indexed gate,
1039         address indexed vault,
1040         NegativeYieldToken nyt,
1041         PerpetualYieldToken pyt
1042     );
1043 
1044     /// -----------------------------------------------------------------------
1045     /// Storage variables
1046     /// -----------------------------------------------------------------------
1047 
1048     struct ProtocolFeeInfo {
1049         uint8 fee; // each increment represents 0.1%, so max is 25.5%
1050         address recipient;
1051     }
1052     /// @notice The protocol fee and the fee recipient address.
1053     ProtocolFeeInfo public protocolFeeInfo;
1054 
1055     /// -----------------------------------------------------------------------
1056     /// Constructor
1057     /// -----------------------------------------------------------------------
1058 
1059     constructor(ProtocolFeeInfo memory protocolFeeInfo_) {
1060         if (
1061             protocolFeeInfo_.fee != 0 &&
1062             protocolFeeInfo_.recipient == address(0)
1063         ) {
1064             revert Error_ProtocolFeeRecipientIsZero();
1065         }
1066         protocolFeeInfo = protocolFeeInfo_;
1067         emit SetProtocolFee(protocolFeeInfo_);
1068     }
1069 
1070     /// -----------------------------------------------------------------------
1071     /// User actions
1072     /// -----------------------------------------------------------------------
1073 
1074     /// @notice Deploys the NegativeYieldToken and PerpetualYieldToken associated with a vault.
1075     /// @dev Will revert if they have already been deployed.
1076     /// @param gate The gate that will use the NYT and PYT
1077     /// @param vault The vault to deploy NYT and PYT for
1078     /// @return nyt The deployed NegativeYieldToken
1079     /// @return pyt The deployed PerpetualYieldToken
1080     function deployYieldTokenPair(Gate gate, address vault)
1081         public
1082         virtual
1083         returns (NegativeYieldToken nyt, PerpetualYieldToken pyt)
1084     {
1085         // Use the CREATE2 opcode to deploy new NegativeYieldToken and PerpetualYieldToken contracts.
1086         // This will revert if the contracts have already been deployed,
1087         // as the salt & bytecode hash would be the same and we can't deploy with it twice.
1088         nyt = new NegativeYieldToken{salt: bytes32(0)}(gate, vault);
1089         pyt = new PerpetualYieldToken{salt: bytes32(0)}(gate, vault);
1090 
1091         emit DeployYieldTokenPair(gate, vault, nyt, pyt);
1092     }
1093 
1094     /// -----------------------------------------------------------------------
1095     /// Getters
1096     /// -----------------------------------------------------------------------
1097 
1098     /// @notice Returns the NegativeYieldToken associated with a gate & vault pair.
1099     /// @dev Returns non-zero value even if the contract hasn't been deployed yet.
1100     /// @param gate The gate to query
1101     /// @param vault The vault to query
1102     /// @return The NegativeYieldToken address
1103     function getNegativeYieldToken(Gate gate, address vault)
1104         public
1105         view
1106         virtual
1107         returns (NegativeYieldToken)
1108     {
1109         return
1110             NegativeYieldToken(_computeYieldTokenAddress(gate, vault, false));
1111     }
1112 
1113     /// @notice Returns the PerpetualYieldToken associated with a gate & vault pair.
1114     /// @dev Returns non-zero value even if the contract hasn't been deployed yet.
1115     /// @param gate The gate to query
1116     /// @param vault The vault to query
1117     /// @return The PerpetualYieldToken address
1118     function getPerpetualYieldToken(Gate gate, address vault)
1119         public
1120         view
1121         virtual
1122         returns (PerpetualYieldToken)
1123     {
1124         return
1125             PerpetualYieldToken(_computeYieldTokenAddress(gate, vault, true));
1126     }
1127 
1128     /// -----------------------------------------------------------------------
1129     /// Owner functions
1130     /// -----------------------------------------------------------------------
1131 
1132     /// @notice Updates the protocol fee and/or the protocol fee recipient.
1133     /// Only callable by the owner.
1134     /// @param protocolFeeInfo_ The new protocol fee info
1135     function ownerSetProtocolFee(ProtocolFeeInfo calldata protocolFeeInfo_)
1136         external
1137         virtual
1138         onlyOwner
1139     {
1140         if (
1141             protocolFeeInfo_.fee != 0 &&
1142             protocolFeeInfo_.recipient == address(0)
1143         ) {
1144             revert Error_ProtocolFeeRecipientIsZero();
1145         }
1146         protocolFeeInfo = protocolFeeInfo_;
1147 
1148         emit SetProtocolFee(protocolFeeInfo_);
1149     }
1150 
1151     /// -----------------------------------------------------------------------
1152     /// Internal utilities
1153     /// -----------------------------------------------------------------------
1154 
1155     /// @dev Computes the address of PYTs and NYTs using CREATE2.
1156     function _computeYieldTokenAddress(
1157         Gate gate,
1158         address vault,
1159         bool isPerpetualYieldToken
1160     ) internal view virtual returns (address) {
1161         return
1162             keccak256(
1163                 abi.encodePacked(
1164                     // Prefix:
1165                     bytes1(0xFF),
1166                     // Creator:
1167                     address(this),
1168                     // Salt:
1169                     bytes32(0),
1170                     // Bytecode hash:
1171                     keccak256(
1172                         abi.encodePacked(
1173                             // Deployment bytecode:
1174                             isPerpetualYieldToken
1175                                 ? type(PerpetualYieldToken).creationCode
1176                                 : type(NegativeYieldToken).creationCode,
1177                             // Constructor arguments:
1178                             abi.encode(gate, vault)
1179                         )
1180                     )
1181                 )
1182             ).fromLast20Bytes(); // Convert the CREATE2 hash into an address.
1183     }
1184 }
1185 
1186 abstract contract IxPYT is ERC4626 {
1187     function sweep(address receiver) external virtual returns (uint256 shares);
1188 }
1189 
1190 /// @title Contains 512-bit math functions
1191 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1192 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1193 library FullMath {
1194     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1195     /// @param a The multiplicand
1196     /// @param b The multiplier
1197     /// @param denominator The divisor
1198     /// @return result The 256-bit result
1199     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1200     function mulDiv(
1201         uint256 a,
1202         uint256 b,
1203         uint256 denominator
1204     ) internal pure returns (uint256 result) {
1205         unchecked {
1206             // 512-bit multiply [prod1 prod0] = a * b
1207             // Compute the product mod 2**256 and mod 2**256 - 1
1208             // then use the Chinese Remainder Theorem to reconstruct
1209             // the 512 bit result. The result is stored in two 256
1210             // variables such that product = prod1 * 2**256 + prod0
1211             uint256 prod0; // Least significant 256 bits of the product
1212             uint256 prod1; // Most significant 256 bits of the product
1213             assembly {
1214                 let mm := mulmod(a, b, not(0))
1215                 prod0 := mul(a, b)
1216                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1217             }
1218 
1219             // Handle non-overflow cases, 256 by 256 division
1220             if (prod1 == 0) {
1221                 require(denominator > 0);
1222                 assembly {
1223                     result := div(prod0, denominator)
1224                 }
1225                 return result;
1226             }
1227 
1228             // Make sure the result is less than 2**256.
1229             // Also prevents denominator == 0
1230             require(denominator > prod1);
1231 
1232             ///////////////////////////////////////////////
1233             // 512 by 256 division.
1234             ///////////////////////////////////////////////
1235 
1236             // Make division exact by subtracting the remainder from [prod1 prod0]
1237             // Compute remainder using mulmod
1238             uint256 remainder;
1239             assembly {
1240                 remainder := mulmod(a, b, denominator)
1241             }
1242             // Subtract 256 bit number from 512 bit number
1243             assembly {
1244                 prod1 := sub(prod1, gt(remainder, prod0))
1245                 prod0 := sub(prod0, remainder)
1246             }
1247 
1248             // Factor powers of two out of denominator
1249             // Compute largest power of two divisor of denominator.
1250             // Always >= 1.
1251             uint256 twos = (0 - denominator) & denominator;
1252             // Divide denominator by power of two
1253             assembly {
1254                 denominator := div(denominator, twos)
1255             }
1256 
1257             // Divide [prod1 prod0] by the factors of two
1258             assembly {
1259                 prod0 := div(prod0, twos)
1260             }
1261             // Shift in bits from prod1 into prod0. For this we need
1262             // to flip `twos` such that it is 2**256 / twos.
1263             // If twos is zero, then it becomes one
1264             assembly {
1265                 twos := add(div(sub(0, twos), twos), 1)
1266             }
1267             prod0 |= prod1 * twos;
1268 
1269             // Invert denominator mod 2**256
1270             // Now that denominator is an odd number, it has an inverse
1271             // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1272             // Compute the inverse by starting with a seed that is correct
1273             // correct for four bits. That is, denominator * inv = 1 mod 2**4
1274             uint256 inv = (3 * denominator) ^ 2;
1275             // Now use Newton-Raphson iteration to improve the precision.
1276             // Thanks to Hensel's lifting lemma, this also works in modular
1277             // arithmetic, doubling the correct bits in each step.
1278             inv *= 2 - denominator * inv; // inverse mod 2**8
1279             inv *= 2 - denominator * inv; // inverse mod 2**16
1280             inv *= 2 - denominator * inv; // inverse mod 2**32
1281             inv *= 2 - denominator * inv; // inverse mod 2**64
1282             inv *= 2 - denominator * inv; // inverse mod 2**128
1283             inv *= 2 - denominator * inv; // inverse mod 2**256
1284 
1285             // Because the division is now exact we can divide by multiplying
1286             // with the modular inverse of denominator. This will give us the
1287             // correct result modulo 2**256. Since the precoditions guarantee
1288             // that the outcome is less than 2**256, this is the final result.
1289             // We don't need to compute the high bits of the result and prod1
1290             // is no longer required.
1291             result = prod0 * inv;
1292             return result;
1293         }
1294     }
1295 
1296     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1297     /// @param a The multiplicand
1298     /// @param b The multiplier
1299     /// @param denominator The divisor
1300     /// @return result The 256-bit result
1301     function mulDivRoundingUp(
1302         uint256 a,
1303         uint256 b,
1304         uint256 denominator
1305     ) internal pure returns (uint256 result) {
1306         unchecked {
1307             result = mulDiv(a, b, denominator);
1308             if (mulmod(a, b, denominator) > 0) {
1309                 require(result < type(uint256).max);
1310                 result++;
1311             }
1312         }
1313     }
1314 }
1315 
1316 /// @title Multicall
1317 /// @notice Enables calling multiple methods in a single call to the contract
1318 abstract contract Multicall {
1319     function multicall(bytes[] calldata data)
1320         external
1321         payable
1322         returns (bytes[] memory results)
1323     {
1324         results = new bytes[](data.length);
1325         for (uint256 i = 0; i < data.length; i++) {
1326             (bool success, bytes memory result) = address(this).delegatecall(
1327                 data[i]
1328             );
1329 
1330             if (!success) {
1331                 // Next 5 lines from https://ethereum.stackexchange.com/a/83577
1332                 if (result.length < 68) revert();
1333                 assembly {
1334                     result := add(result, 0x04)
1335                 }
1336                 revert(abi.decode(result, (string)));
1337             }
1338 
1339             results[i] = result;
1340         }
1341     }
1342 }
1343 
1344 /// @title Self Permit
1345 /// @notice Functionality to call permit on any EIP-2612-compliant token for use in the route
1346 /// @dev These functions are expected to be embedded in multicalls to allow EOAs to approve a contract and call a function
1347 /// that requires an approval in a single transaction.
1348 abstract contract SelfPermit {
1349     function selfPermit(
1350         ERC20 token,
1351         uint256 value,
1352         uint256 deadline,
1353         uint8 v,
1354         bytes32 r,
1355         bytes32 s
1356     ) public payable {
1357         token.permit(msg.sender, address(this), value, deadline, v, r, s);
1358     }
1359 
1360     function selfPermitIfNecessary(
1361         ERC20 token,
1362         uint256 value,
1363         uint256 deadline,
1364         uint8 v,
1365         bytes32 r,
1366         bytes32 s
1367     ) external payable {
1368         if (token.allowance(msg.sender, address(this)) < value)
1369             selfPermit(token, value, deadline, v, r, s);
1370     }
1371 }
1372 
1373 /// @title Gate
1374 /// @author zefram.eth
1375 /// @notice Gate is the main contract users interact with to mint/burn NegativeYieldToken
1376 /// and PerpetualYieldToken, as well as claim the yield earned by PYTs.
1377 /// @dev Gate is an abstract contract that should be inherited from in order to support
1378 /// a specific vault protocol (e.g. YearnGate supports YearnVault). Each Gate handles
1379 /// all vaults & associated NYTs/PYTs of a specific vault protocol.
1380 ///
1381 /// Vaults are yield-generating contracts used by Gate. Gate makes several assumptions about
1382 /// a vault:
1383 /// 1) A vault has a single associated underlying token that is immutable.
1384 /// 2) A vault gives depositors yield denominated in the underlying token.
1385 /// 3) A vault depositor owns shares in the vault, which represents their deposit.
1386 /// 4) Vaults have a notion of "price per share", which is the amount of underlying tokens
1387 ///    each vault share can be redeemed for.
1388 /// 5) If vault shares are represented using an ERC20 token, then the ERC20 token contract must be
1389 ///    the vault contract itself.
1390 abstract contract Gate is
1391     ReentrancyGuard,
1392     Multicall,
1393     SelfPermit,
1394     BoringOwnable
1395 {
1396     /// -----------------------------------------------------------------------
1397     /// Library usage
1398     /// -----------------------------------------------------------------------
1399 
1400     using SafeTransferLib for ERC20;
1401     using SafeTransferLib for ERC4626;
1402 
1403     /// -----------------------------------------------------------------------
1404     /// Errors
1405     /// -----------------------------------------------------------------------
1406 
1407     error Error_InvalidInput();
1408     error Error_VaultSharesNotERC20();
1409     error Error_TokenPairNotDeployed();
1410     error Error_EmergencyExitNotActivated();
1411     error Error_SenderNotPerpetualYieldToken();
1412     error Error_EmergencyExitAlreadyActivated();
1413 
1414     /// -----------------------------------------------------------------------
1415     /// Events
1416     /// -----------------------------------------------------------------------
1417 
1418     event EnterWithUnderlying(
1419         address sender,
1420         address indexed nytRecipient,
1421         address indexed pytRecipient,
1422         address indexed vault,
1423         IxPYT xPYT,
1424         uint256 underlyingAmount
1425     );
1426     event EnterWithVaultShares(
1427         address sender,
1428         address indexed nytRecipient,
1429         address indexed pytRecipient,
1430         address indexed vault,
1431         IxPYT xPYT,
1432         uint256 vaultSharesAmount
1433     );
1434     event ExitToUnderlying(
1435         address indexed sender,
1436         address indexed recipient,
1437         address indexed vault,
1438         IxPYT xPYT,
1439         uint256 underlyingAmount
1440     );
1441     event ExitToVaultShares(
1442         address indexed sender,
1443         address indexed recipient,
1444         address indexed vault,
1445         IxPYT xPYT,
1446         uint256 vaultSharesAmount
1447     );
1448     event ClaimYieldInUnderlying(
1449         address indexed sender,
1450         address indexed recipient,
1451         address indexed vault,
1452         uint256 underlyingAmount
1453     );
1454     event ClaimYieldInVaultShares(
1455         address indexed sender,
1456         address indexed recipient,
1457         address indexed vault,
1458         uint256 vaultSharesAmount
1459     );
1460     event ClaimYieldAndEnter(
1461         address sender,
1462         address indexed nytRecipient,
1463         address indexed pytRecipient,
1464         address indexed vault,
1465         IxPYT xPYT,
1466         uint256 amount
1467     );
1468 
1469     /// -----------------------------------------------------------------------
1470     /// Structs
1471     /// -----------------------------------------------------------------------
1472 
1473     /// @param activated True if emergency exit has been activated, false if not
1474     /// @param pytPriceInUnderlying The amount of underlying assets each PYT can redeem for.
1475     /// Should be a value in the range [0, PRECISION]
1476     struct EmergencyExitStatus {
1477         bool activated;
1478         uint96 pytPriceInUnderlying;
1479     }
1480 
1481     /// -----------------------------------------------------------------------
1482     /// Constants
1483     /// -----------------------------------------------------------------------
1484 
1485     /// @notice The decimals of precision used by yieldPerTokenStored and pricePerVaultShareStored
1486     uint256 internal constant PRECISION_DECIMALS = 27;
1487 
1488     /// @notice The precision used by yieldPerTokenStored and pricePerVaultShareStored
1489     uint256 internal constant PRECISION = 10**PRECISION_DECIMALS;
1490 
1491     /// -----------------------------------------------------------------------
1492     /// Immutable parameters
1493     /// -----------------------------------------------------------------------
1494 
1495     Factory public immutable factory;
1496 
1497     /// -----------------------------------------------------------------------
1498     /// Storage variables
1499     /// -----------------------------------------------------------------------
1500 
1501     /// @notice The amount of underlying tokens each vault share is worth, at the time of the last update.
1502     /// Uses PRECISION.
1503     /// @dev vault => value
1504     mapping(address => uint256) public pricePerVaultShareStored;
1505 
1506     /// @notice The amount of yield each PYT has accrued, at the time of the last update.
1507     /// Scaled by PRECISION.
1508     /// @dev vault => value
1509     mapping(address => uint256) public yieldPerTokenStored;
1510 
1511     /// @notice The amount of yield each PYT has accrued, at the time when a user has last interacted
1512     /// with the gate/PYT. Shifted by 1, so e.g. 3 represents 2, 10 represents 9.
1513     /// @dev vault => user => value
1514     /// The value is shifted to use 0 for representing uninitialized users.
1515     mapping(address => mapping(address => uint256))
1516         public userYieldPerTokenStored;
1517 
1518     /// @notice The amount of yield a user has accrued, at the time when they last interacted
1519     /// with the gate/PYT (without calling claimYieldInUnderlying()).
1520     /// Shifted by 1, so e.g. 3 represents 2, 10 represents 9.
1521     /// @dev vault => user => value
1522     mapping(address => mapping(address => uint256)) public userAccruedYield;
1523 
1524     /// @notice Stores info relevant to emergency exits of a vault.
1525     /// @dev vault => value
1526     mapping(address => EmergencyExitStatus) public emergencyExitStatusOfVault;
1527 
1528     /// -----------------------------------------------------------------------
1529     /// Initialization
1530     /// -----------------------------------------------------------------------
1531 
1532     constructor(Factory factory_) {
1533         factory = factory_;
1534     }
1535 
1536     /// -----------------------------------------------------------------------
1537     /// User actions
1538     /// -----------------------------------------------------------------------
1539 
1540     /// @notice Converts underlying tokens into NegativeYieldToken and PerpetualYieldToken.
1541     /// The amount of NYT and PYT minted will be equal to the underlying token amount.
1542     /// @dev The underlying tokens will be immediately deposited into the specified vault.
1543     /// If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1544     /// deploy them before proceeding, which will increase the gas cost significantly.
1545     /// @param nytRecipient The recipient of the minted NYT
1546     /// @param pytRecipient The recipient of the minted PYT
1547     /// @param vault The vault to mint NYT and PYT for
1548     /// @param xPYT The xPYT contract to deposit the minted PYT into. Set to 0 to receive raw PYT instead.
1549     /// @param underlyingAmount The amount of underlying tokens to use
1550     /// @return mintAmount The amount of NYT and PYT minted (the amounts are equal)
1551     function enterWithUnderlying(
1552         address nytRecipient,
1553         address pytRecipient,
1554         address vault,
1555         IxPYT xPYT,
1556         uint256 underlyingAmount
1557     ) external virtual nonReentrant returns (uint256 mintAmount) {
1558         /// -----------------------------------------------------------------------
1559         /// Validation
1560         /// -----------------------------------------------------------------------
1561 
1562         if (underlyingAmount == 0) {
1563             return 0;
1564         }
1565 
1566         /// -----------------------------------------------------------------------
1567         /// State updates & effects
1568         /// -----------------------------------------------------------------------
1569 
1570         // mint PYT and NYT
1571         mintAmount = underlyingAmount;
1572         _enter(
1573             nytRecipient,
1574             pytRecipient,
1575             vault,
1576             xPYT,
1577             underlyingAmount,
1578             getPricePerVaultShare(vault)
1579         );
1580 
1581         // transfer underlying from msg.sender to address(this)
1582         ERC20 underlying = getUnderlyingOfVault(vault);
1583         underlying.safeTransferFrom(
1584             msg.sender,
1585             address(this),
1586             underlyingAmount
1587         );
1588 
1589         // deposit underlying into vault
1590         _depositIntoVault(underlying, underlyingAmount, vault);
1591 
1592         emit EnterWithUnderlying(
1593             msg.sender,
1594             nytRecipient,
1595             pytRecipient,
1596             vault,
1597             xPYT,
1598             underlyingAmount
1599         );
1600     }
1601 
1602     /// @notice Converts vault share tokens into NegativeYieldToken and PerpetualYieldToken.
1603     /// @dev Only available if vault shares are transferrable ERC20 tokens.
1604     /// If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1605     /// deploy them before proceeding, which will increase the gas cost significantly.
1606     /// @param nytRecipient The recipient of the minted NYT
1607     /// @param pytRecipient The recipient of the minted PYT
1608     /// @param vault The vault to mint NYT and PYT for
1609     /// @param xPYT The xPYT contract to deposit the minted PYT into. Set to 0 to receive raw PYT instead.
1610     /// @param vaultSharesAmount The amount of vault share tokens to use
1611     /// @return mintAmount The amount of NYT and PYT minted (the amounts are equal)
1612     function enterWithVaultShares(
1613         address nytRecipient,
1614         address pytRecipient,
1615         address vault,
1616         IxPYT xPYT,
1617         uint256 vaultSharesAmount
1618     ) external virtual nonReentrant returns (uint256 mintAmount) {
1619         /// -----------------------------------------------------------------------
1620         /// Validation
1621         /// -----------------------------------------------------------------------
1622 
1623         if (vaultSharesAmount == 0) {
1624             return 0;
1625         }
1626 
1627         // only supported if vault shares are ERC20
1628         if (!vaultSharesIsERC20()) {
1629             revert Error_VaultSharesNotERC20();
1630         }
1631 
1632         /// -----------------------------------------------------------------------
1633         /// State updates & effects
1634         /// -----------------------------------------------------------------------
1635 
1636         // mint PYT and NYT
1637         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
1638         mintAmount = _vaultSharesAmountToUnderlyingAmount(
1639             vault,
1640             vaultSharesAmount,
1641             updatedPricePerVaultShare
1642         );
1643         _enter(
1644             nytRecipient,
1645             pytRecipient,
1646             vault,
1647             xPYT,
1648             mintAmount,
1649             updatedPricePerVaultShare
1650         );
1651 
1652         // transfer vault tokens from msg.sender to address(this)
1653         ERC20(vault).safeTransferFrom(
1654             msg.sender,
1655             address(this),
1656             vaultSharesAmount
1657         );
1658 
1659         emit EnterWithVaultShares(
1660             msg.sender,
1661             nytRecipient,
1662             pytRecipient,
1663             vault,
1664             xPYT,
1665             vaultSharesAmount
1666         );
1667     }
1668 
1669     /// @notice Converts NegativeYieldToken and PerpetualYieldToken to underlying tokens.
1670     /// The amount of NYT and PYT burned will be equal to the underlying token amount.
1671     /// @dev The underlying tokens will be immediately withdrawn from the specified vault.
1672     /// If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1673     /// revert.
1674     /// @param recipient The recipient of the minted NYT and PYT
1675     /// @param vault The vault to mint NYT and PYT for
1676     /// @param xPYT The xPYT contract to use for burning PYT. Set to 0 to burn raw PYT instead.
1677     /// @param underlyingAmount The amount of underlying tokens requested
1678     /// @return burnAmount The amount of NYT and PYT burned (the amounts are equal)
1679     function exitToUnderlying(
1680         address recipient,
1681         address vault,
1682         IxPYT xPYT,
1683         uint256 underlyingAmount
1684     ) external virtual nonReentrant returns (uint256 burnAmount) {
1685         /// -----------------------------------------------------------------------
1686         /// Validation
1687         /// -----------------------------------------------------------------------
1688 
1689         if (underlyingAmount == 0) {
1690             return 0;
1691         }
1692 
1693         /// -----------------------------------------------------------------------
1694         /// State updates & effects
1695         /// -----------------------------------------------------------------------
1696 
1697         // burn PYT and NYT
1698         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
1699         burnAmount = underlyingAmount;
1700         _exit(vault, xPYT, underlyingAmount, updatedPricePerVaultShare);
1701 
1702         // withdraw underlying from vault to recipient
1703         // don't check balance since user can just withdraw slightly less
1704         // saves gas this way
1705         underlyingAmount = _withdrawFromVault(
1706             recipient,
1707             vault,
1708             underlyingAmount,
1709             updatedPricePerVaultShare,
1710             false
1711         );
1712 
1713         emit ExitToUnderlying(
1714             msg.sender,
1715             recipient,
1716             vault,
1717             xPYT,
1718             underlyingAmount
1719         );
1720     }
1721 
1722     /// @notice Converts NegativeYieldToken and PerpetualYieldToken to vault share tokens.
1723     /// The amount of NYT and PYT burned will be equal to the underlying token amount.
1724     /// @dev Only available if vault shares are transferrable ERC20 tokens.
1725     /// If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1726     /// revert.
1727     /// @param recipient The recipient of the minted NYT and PYT
1728     /// @param vault The vault to mint NYT and PYT for
1729     /// @param xPYT The xPYT contract to use for burning PYT. Set to 0 to burn raw PYT instead.
1730     /// @param vaultSharesAmount The amount of vault share tokens requested
1731     /// @return burnAmount The amount of NYT and PYT burned (the amounts are equal)
1732     function exitToVaultShares(
1733         address recipient,
1734         address vault,
1735         IxPYT xPYT,
1736         uint256 vaultSharesAmount
1737     ) external virtual nonReentrant returns (uint256 burnAmount) {
1738         /// -----------------------------------------------------------------------
1739         /// Validation
1740         /// -----------------------------------------------------------------------
1741 
1742         if (vaultSharesAmount == 0) {
1743             return 0;
1744         }
1745 
1746         // only supported if vault shares are ERC20
1747         if (!vaultSharesIsERC20()) {
1748             revert Error_VaultSharesNotERC20();
1749         }
1750 
1751         /// -----------------------------------------------------------------------
1752         /// State updates & effects
1753         /// -----------------------------------------------------------------------
1754 
1755         // burn PYT and NYT
1756         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
1757         burnAmount = _vaultSharesAmountToUnderlyingAmountRoundingUp(
1758             vault,
1759             vaultSharesAmount,
1760             updatedPricePerVaultShare
1761         );
1762         _exit(vault, xPYT, burnAmount, updatedPricePerVaultShare);
1763 
1764         // transfer vault tokens to recipient
1765         ERC20(vault).safeTransfer(recipient, vaultSharesAmount);
1766 
1767         emit ExitToVaultShares(
1768             msg.sender,
1769             recipient,
1770             vault,
1771             xPYT,
1772             vaultSharesAmount
1773         );
1774     }
1775 
1776     /// @notice Claims the yield earned by the PerpetualYieldToken balance of msg.sender, in the underlying token.
1777     /// @dev If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1778     /// revert.
1779     /// @param recipient The recipient of the yield
1780     /// @param vault The vault to claim yield from
1781     /// @return yieldAmount The amount of yield claimed, in underlying tokens
1782     function claimYieldInUnderlying(address recipient, address vault)
1783         external
1784         virtual
1785         nonReentrant
1786         returns (uint256 yieldAmount)
1787     {
1788         /// -----------------------------------------------------------------------
1789         /// State updates
1790         /// -----------------------------------------------------------------------
1791 
1792         // update storage variables and compute yield amount
1793         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
1794         yieldAmount = _claimYield(vault, updatedPricePerVaultShare);
1795 
1796         // withdraw yield
1797         if (yieldAmount != 0) {
1798             /// -----------------------------------------------------------------------
1799             /// Effects
1800             /// -----------------------------------------------------------------------
1801 
1802             (uint8 fee, address protocolFeeRecipient) = factory
1803                 .protocolFeeInfo();
1804 
1805             if (fee != 0) {
1806                 uint256 protocolFee = (yieldAmount * fee) / 1000;
1807                 unchecked {
1808                     // can't underflow since fee < 256
1809                     yieldAmount -= protocolFee;
1810                 }
1811 
1812                 if (vaultSharesIsERC20()) {
1813                     // vault shares are in ERC20
1814                     // do share transfer
1815                     protocolFee = _underlyingAmountToVaultSharesAmount(
1816                         vault,
1817                         protocolFee,
1818                         updatedPricePerVaultShare
1819                     );
1820                     uint256 vaultSharesBalance = ERC20(vault).balanceOf(
1821                         address(this)
1822                     );
1823                     if (protocolFee > vaultSharesBalance) {
1824                         protocolFee = vaultSharesBalance;
1825                     }
1826                     if (protocolFee != 0) {
1827                         ERC20(vault).safeTransfer(
1828                             protocolFeeRecipient,
1829                             protocolFee
1830                         );
1831                     }
1832                 } else {
1833                     // vault shares are not in ERC20
1834                     // withdraw underlying from vault
1835                     // checkBalance is set to true to prevent getting stuck
1836                     // due to rounding errors
1837                     if (protocolFee != 0) {
1838                         _withdrawFromVault(
1839                             protocolFeeRecipient,
1840                             vault,
1841                             protocolFee,
1842                             updatedPricePerVaultShare,
1843                             true
1844                         );
1845                     }
1846                 }
1847             }
1848 
1849             // withdraw underlying to recipient
1850             // checkBalance is set to true to prevent getting stuck
1851             // due to rounding errors
1852             yieldAmount = _withdrawFromVault(
1853                 recipient,
1854                 vault,
1855                 yieldAmount,
1856                 updatedPricePerVaultShare,
1857                 true
1858             );
1859 
1860             emit ClaimYieldInUnderlying(
1861                 msg.sender,
1862                 recipient,
1863                 vault,
1864                 yieldAmount
1865             );
1866         }
1867     }
1868 
1869     /// @notice Claims the yield earned by the PerpetualYieldToken balance of msg.sender, in vault shares.
1870     /// @dev Only available if vault shares are transferrable ERC20 tokens.
1871     /// If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1872     /// revert.
1873     /// @param recipient The recipient of the yield
1874     /// @param vault The vault to claim yield from
1875     /// @return yieldAmount The amount of yield claimed, in vault shares
1876     function claimYieldInVaultShares(address recipient, address vault)
1877         external
1878         virtual
1879         nonReentrant
1880         returns (uint256 yieldAmount)
1881     {
1882         /// -----------------------------------------------------------------------
1883         /// Validation
1884         /// -----------------------------------------------------------------------
1885 
1886         // only supported if vault shares are ERC20
1887         if (!vaultSharesIsERC20()) {
1888             revert Error_VaultSharesNotERC20();
1889         }
1890 
1891         /// -----------------------------------------------------------------------
1892         /// State updates
1893         /// -----------------------------------------------------------------------
1894 
1895         // update storage variables and compute yield amount
1896         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
1897         yieldAmount = _claimYield(vault, updatedPricePerVaultShare);
1898 
1899         // withdraw yield
1900         if (yieldAmount != 0) {
1901             /// -----------------------------------------------------------------------
1902             /// Effects
1903             /// -----------------------------------------------------------------------
1904 
1905             // convert yieldAmount to be denominated in vault shares
1906             yieldAmount = _underlyingAmountToVaultSharesAmount(
1907                 vault,
1908                 yieldAmount,
1909                 updatedPricePerVaultShare
1910             );
1911 
1912             (uint8 fee, address protocolFeeRecipient) = factory
1913                 .protocolFeeInfo();
1914             uint256 vaultSharesBalance = getVaultShareBalance(vault);
1915             if (fee != 0) {
1916                 uint256 protocolFee = (yieldAmount * fee) / 1000;
1917                 protocolFee = protocolFee > vaultSharesBalance
1918                     ? vaultSharesBalance
1919                     : protocolFee;
1920                 unchecked {
1921                     // can't underflow since fee < 256
1922                     yieldAmount -= protocolFee;
1923                 }
1924 
1925                 if (protocolFee > 0) {
1926                     ERC20(vault).safeTransfer(
1927                         protocolFeeRecipient,
1928                         protocolFee
1929                     );
1930 
1931                     vaultSharesBalance -= protocolFee;
1932                 }
1933             }
1934 
1935             // transfer vault shares to recipient
1936             // check if vault shares is enough to prevent getting stuck
1937             // from rounding errors
1938             yieldAmount = yieldAmount > vaultSharesBalance
1939                 ? vaultSharesBalance
1940                 : yieldAmount;
1941             if (yieldAmount > 0) {
1942                 ERC20(vault).safeTransfer(recipient, yieldAmount);
1943             }
1944 
1945             emit ClaimYieldInVaultShares(
1946                 msg.sender,
1947                 recipient,
1948                 vault,
1949                 yieldAmount
1950             );
1951         }
1952     }
1953 
1954     /// @notice Claims the yield earned by the PerpetualYieldToken balance of msg.sender, and immediately
1955     /// use the yield to mint NYT and PYT.
1956     /// @dev Introduced to save gas for xPYT compounding, since it avoids vault withdraws/transfers.
1957     /// If the NYT and PYT for the specified vault haven't been deployed yet, this call will
1958     /// revert.
1959     /// @param nytRecipient The recipient of the minted NYT
1960     /// @param pytRecipient The recipient of the minted PYT
1961     /// @param vault The vault to claim yield from
1962     /// @param xPYT The xPYT contract to deposit the minted PYT into. Set to 0 to receive raw PYT instead.
1963     /// @return yieldAmount The amount of yield claimed, in underlying tokens
1964     function claimYieldAndEnter(
1965         address nytRecipient,
1966         address pytRecipient,
1967         address vault,
1968         IxPYT xPYT
1969     ) external virtual nonReentrant returns (uint256 yieldAmount) {
1970         // update storage variables and compute yield amount
1971         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
1972         yieldAmount = _claimYield(vault, updatedPricePerVaultShare);
1973 
1974         // use yield to mint NYT and PYT
1975         if (yieldAmount != 0) {
1976             (uint8 fee, address protocolFeeRecipient) = factory
1977                 .protocolFeeInfo();
1978 
1979             if (fee != 0) {
1980                 uint256 protocolFee = (yieldAmount * fee) / 1000;
1981                 unchecked {
1982                     // can't underflow since fee < 256
1983                     yieldAmount -= protocolFee;
1984                 }
1985 
1986                 if (vaultSharesIsERC20()) {
1987                     // vault shares are in ERC20
1988                     // do share transfer
1989                     protocolFee = _underlyingAmountToVaultSharesAmount(
1990                         vault,
1991                         protocolFee,
1992                         updatedPricePerVaultShare
1993                     );
1994                     uint256 vaultSharesBalance = ERC20(vault).balanceOf(
1995                         address(this)
1996                     );
1997                     if (protocolFee > vaultSharesBalance) {
1998                         protocolFee = vaultSharesBalance;
1999                     }
2000                     if (protocolFee != 0) {
2001                         ERC20(vault).safeTransfer(
2002                             protocolFeeRecipient,
2003                             protocolFee
2004                         );
2005                     }
2006                 } else {
2007                     // vault shares are not in ERC20
2008                     // withdraw underlying from vault
2009                     // checkBalance is set to true to prevent getting stuck
2010                     // due to rounding errors
2011                     if (protocolFee != 0) {
2012                         _withdrawFromVault(
2013                             protocolFeeRecipient,
2014                             vault,
2015                             protocolFee,
2016                             updatedPricePerVaultShare,
2017                             true
2018                         );
2019                     }
2020                 }
2021             }
2022 
2023             NegativeYieldToken nyt = getNegativeYieldTokenForVault(vault);
2024             PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2025 
2026             if (address(xPYT) == address(0)) {
2027                 // accrue yield to pytRecipient if they're not msg.sender
2028                 // no need to do it if the recipient is msg.sender, since
2029                 // we already accrued yield in _claimYield
2030                 if (pytRecipient != msg.sender) {
2031                     _accrueYield(
2032                         vault,
2033                         pyt,
2034                         pytRecipient,
2035                         updatedPricePerVaultShare
2036                     );
2037                 }
2038             } else {
2039                 // accrue yield to xPYT contract since it gets minted PYT
2040                 _accrueYield(
2041                     vault,
2042                     pyt,
2043                     address(xPYT),
2044                     updatedPricePerVaultShare
2045                 );
2046             }
2047 
2048             // mint NYTs and PYTs
2049             nyt.gateMint(nytRecipient, yieldAmount);
2050             if (address(xPYT) == address(0)) {
2051                 // mint raw PYT to recipient
2052                 pyt.gateMint(pytRecipient, yieldAmount);
2053             } else {
2054                 // mint PYT to xPYT contract
2055                 pyt.gateMint(address(xPYT), yieldAmount);
2056 
2057                 /// -----------------------------------------------------------------------
2058                 /// Effects
2059                 /// -----------------------------------------------------------------------
2060 
2061                 // call sweep to mint xPYT using the PYT
2062                 xPYT.sweep(pytRecipient);
2063             }
2064 
2065             emit ClaimYieldAndEnter(
2066                 msg.sender,
2067                 nytRecipient,
2068                 pytRecipient,
2069                 vault,
2070                 xPYT,
2071                 yieldAmount
2072             );
2073         }
2074     }
2075 
2076     /// -----------------------------------------------------------------------
2077     /// Getters
2078     /// -----------------------------------------------------------------------
2079 
2080     /// @notice Returns the NegativeYieldToken associated with a vault.
2081     /// @dev Returns non-zero value even if the contract hasn't been deployed yet.
2082     /// @param vault The vault to query
2083     /// @return The NegativeYieldToken address
2084     function getNegativeYieldTokenForVault(address vault)
2085         public
2086         view
2087         virtual
2088         returns (NegativeYieldToken)
2089     {
2090         return factory.getNegativeYieldToken(this, vault);
2091     }
2092 
2093     /// @notice Returns the PerpetualYieldToken associated with a vault.
2094     /// @dev Returns non-zero value even if the contract hasn't been deployed yet.
2095     /// @param vault The vault to query
2096     /// @return The PerpetualYieldToken address
2097     function getPerpetualYieldTokenForVault(address vault)
2098         public
2099         view
2100         virtual
2101         returns (PerpetualYieldToken)
2102     {
2103         return factory.getPerpetualYieldToken(this, vault);
2104     }
2105 
2106     /// @notice Returns the amount of yield claimable by a PerpetualYieldToken holder from a vault.
2107     /// Accounts for protocol fees.
2108     /// @param vault The vault to query
2109     /// @param user The PYT holder to query
2110     /// @return yieldAmount The amount of yield claimable
2111     function getClaimableYieldAmount(address vault, address user)
2112         external
2113         view
2114         virtual
2115         returns (uint256 yieldAmount)
2116     {
2117         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2118         uint256 userYieldPerTokenStored_ = userYieldPerTokenStored[vault][user];
2119         if (userYieldPerTokenStored_ == 0) {
2120             // uninitialized account
2121             return 0;
2122         }
2123         yieldAmount = _getClaimableYieldAmount(
2124             vault,
2125             user,
2126             _computeYieldPerToken(vault, pyt, getPricePerVaultShare(vault)),
2127             userYieldPerTokenStored_,
2128             pyt.balanceOf(user)
2129         );
2130         (uint8 fee, ) = factory.protocolFeeInfo();
2131         if (fee != 0) {
2132             uint256 protocolFee = (yieldAmount * fee) / 1000;
2133             unchecked {
2134                 // can't underflow since fee < 256
2135                 yieldAmount -= protocolFee;
2136             }
2137         }
2138     }
2139 
2140     /// @notice Computes the latest yieldPerToken value for a vault.
2141     /// @param vault The vault to query
2142     /// @return The latest yieldPerToken value
2143     function computeYieldPerToken(address vault)
2144         external
2145         view
2146         virtual
2147         returns (uint256)
2148     {
2149         return
2150             _computeYieldPerToken(
2151                 vault,
2152                 getPerpetualYieldTokenForVault(vault),
2153                 getPricePerVaultShare(vault)
2154             );
2155     }
2156 
2157     /// @notice Returns the underlying token of a vault.
2158     /// @param vault The vault to query
2159     /// @return The underlying token
2160     function getUnderlyingOfVault(address vault)
2161         public
2162         view
2163         virtual
2164         returns (ERC20);
2165 
2166     /// @notice Returns the amount of underlying tokens each share of a vault is worth.
2167     /// @param vault The vault to query
2168     /// @return The pricePerVaultShare value
2169     function getPricePerVaultShare(address vault)
2170         public
2171         view
2172         virtual
2173         returns (uint256);
2174 
2175     /// @notice Returns the amount of vault shares owned by the gate.
2176     /// @param vault The vault to query
2177     /// @return The gate's vault share balance
2178     function getVaultShareBalance(address vault)
2179         public
2180         view
2181         virtual
2182         returns (uint256);
2183 
2184     /// @return True if the vaults supported by this gate use transferrable ERC20 tokens
2185     /// to represent shares, false otherwise.
2186     function vaultSharesIsERC20() public pure virtual returns (bool);
2187 
2188     /// @notice Computes the ERC20 name of the NegativeYieldToken of a vault.
2189     /// @param vault The vault to query
2190     /// @return The ERC20 name
2191     function negativeYieldTokenName(address vault)
2192         external
2193         view
2194         virtual
2195         returns (string memory);
2196 
2197     /// @notice Computes the ERC20 symbol of the NegativeYieldToken of a vault.
2198     /// @param vault The vault to query
2199     /// @return The ERC20 symbol
2200     function negativeYieldTokenSymbol(address vault)
2201         external
2202         view
2203         virtual
2204         returns (string memory);
2205 
2206     /// @notice Computes the ERC20 name of the PerpetualYieldToken of a vault.
2207     /// @param vault The vault to query
2208     /// @return The ERC20 name
2209     function perpetualYieldTokenName(address vault)
2210         external
2211         view
2212         virtual
2213         returns (string memory);
2214 
2215     /// @notice Computes the ERC20 symbol of the NegativeYieldToken of a vault.
2216     /// @param vault The vault to query
2217     /// @return The ERC20 symbol
2218     function perpetualYieldTokenSymbol(address vault)
2219         external
2220         view
2221         virtual
2222         returns (string memory);
2223 
2224     /// -----------------------------------------------------------------------
2225     /// PYT transfer hook
2226     /// -----------------------------------------------------------------------
2227 
2228     /// @notice SHOULD NOT BE CALLED BY USERS, ONLY CALLED BY PERPETUAL YIELD TOKEN CONTRACTS
2229     /// @dev Called by PYT contracts deployed by this gate before each token transfer, in order to
2230     /// accrue the yield earned by the from & to accounts
2231     /// @param from The token transfer from account
2232     /// @param to The token transfer to account
2233     /// @param fromBalance The token balance of the from account before the transfer
2234     /// @param toBalance The token balance of the to account before the transfer
2235     function beforePerpetualYieldTokenTransfer(
2236         address from,
2237         address to,
2238         uint256 amount,
2239         uint256 fromBalance,
2240         uint256 toBalance
2241     ) external virtual {
2242         /// -----------------------------------------------------------------------
2243         /// Validation
2244         /// -----------------------------------------------------------------------
2245 
2246         if (amount == 0) {
2247             return;
2248         }
2249 
2250         address vault = PerpetualYieldToken(msg.sender).vault();
2251         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2252         if (msg.sender != address(pyt)) {
2253             revert Error_SenderNotPerpetualYieldToken();
2254         }
2255 
2256         /// -----------------------------------------------------------------------
2257         /// State updates
2258         /// -----------------------------------------------------------------------
2259 
2260         // accrue yield
2261         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
2262         uint256 updatedYieldPerToken = _computeYieldPerToken(
2263             vault,
2264             pyt,
2265             updatedPricePerVaultShare
2266         );
2267         yieldPerTokenStored[vault] = updatedYieldPerToken;
2268         pricePerVaultShareStored[vault] = updatedPricePerVaultShare;
2269 
2270         // we know the from account must have held PYTs before
2271         // so we will always accrue the yield earned by the from account
2272         userAccruedYield[vault][from] =
2273             _getClaimableYieldAmount(
2274                 vault,
2275                 from,
2276                 updatedYieldPerToken,
2277                 userYieldPerTokenStored[vault][from],
2278                 fromBalance
2279             ) +
2280             1;
2281         userYieldPerTokenStored[vault][from] = updatedYieldPerToken + 1;
2282 
2283         // the to account might not have held PYTs before
2284         // we only accrue yield if they have
2285         uint256 toUserYieldPerTokenStored = userYieldPerTokenStored[vault][to];
2286         if (toUserYieldPerTokenStored != 0) {
2287             // to account has held PYTs before
2288             userAccruedYield[vault][to] =
2289                 _getClaimableYieldAmount(
2290                     vault,
2291                     to,
2292                     updatedYieldPerToken,
2293                     toUserYieldPerTokenStored,
2294                     toBalance
2295                 ) +
2296                 1;
2297         }
2298         userYieldPerTokenStored[vault][to] = updatedYieldPerToken + 1;
2299     }
2300 
2301     /// -----------------------------------------------------------------------
2302     /// Emergency exit
2303     /// -----------------------------------------------------------------------
2304 
2305     /// @notice Activates the emergency exit mode for a certain vault. Only callable by owner.
2306     /// @dev Activating emergency exit allows PYT/NYT holders to do single-sided burns to redeem the underlying
2307     /// collateral. This is to prevent cases where a large portion of PYT/NYT is locked up in a buggy/malicious contract
2308     /// and locks up the underlying collateral forever.
2309     /// @param vault The vault to activate emergency exit for
2310     /// @param pytPriceInUnderlying The amount of underlying asset burning each PYT can redeem. Scaled by PRECISION.
2311     function ownerActivateEmergencyExitForVault(
2312         address vault,
2313         uint96 pytPriceInUnderlying
2314     ) external virtual onlyOwner {
2315         /// -----------------------------------------------------------------------
2316         /// Validation
2317         /// -----------------------------------------------------------------------
2318 
2319         // we only allow emergency exit to be activated once (until deactivation)
2320         // because if pytPriceInUnderlying is ever modified after activation
2321         // then PYT/NYT will become unbacked
2322         if (emergencyExitStatusOfVault[vault].activated) {
2323             revert Error_EmergencyExitAlreadyActivated();
2324         }
2325 
2326         // we need to ensure the PYT price value is within the range [0, PRECISION]
2327         if (pytPriceInUnderlying > PRECISION) {
2328             revert Error_InvalidInput();
2329         }
2330 
2331         // the PYT & NYT must have already been deployed
2332         NegativeYieldToken nyt = getNegativeYieldTokenForVault(vault);
2333         if (address(nyt).code.length == 0) {
2334             revert Error_TokenPairNotDeployed();
2335         }
2336 
2337         /// -----------------------------------------------------------------------
2338         /// State updates
2339         /// -----------------------------------------------------------------------
2340 
2341         emergencyExitStatusOfVault[vault] = EmergencyExitStatus({
2342             activated: true,
2343             pytPriceInUnderlying: pytPriceInUnderlying
2344         });
2345     }
2346 
2347     /// @notice Deactivates the emergency exit mode for a certain vault. Only callable by owner.
2348     /// @param vault The vault to deactivate emergency exit for
2349     function ownerDeactivateEmergencyExitForVault(address vault)
2350         external
2351         virtual
2352         onlyOwner
2353     {
2354         /// -----------------------------------------------------------------------
2355         /// Validation
2356         /// -----------------------------------------------------------------------
2357 
2358         // can only deactivate emergency exit when it's already activated
2359         if (!emergencyExitStatusOfVault[vault].activated) {
2360             revert Error_EmergencyExitNotActivated();
2361         }
2362 
2363         /// -----------------------------------------------------------------------
2364         /// State updates
2365         /// -----------------------------------------------------------------------
2366 
2367         // reset the emergency exit status
2368         delete emergencyExitStatusOfVault[vault];
2369     }
2370 
2371     /// @notice Emergency exit NYTs into the underlying asset. Only callable when emergency exit has
2372     /// been activated for the vault.
2373     /// @param vault The vault to exit NYT for
2374     /// @param amount The amount of NYT to exit
2375     /// @param recipient The recipient of the underlying asset
2376     /// @return underlyingAmount The amount of underlying asset exited
2377     function emergencyExitNegativeYieldToken(
2378         address vault,
2379         uint256 amount,
2380         address recipient
2381     ) external virtual returns (uint256 underlyingAmount) {
2382         /// -----------------------------------------------------------------------
2383         /// Validation
2384         /// -----------------------------------------------------------------------
2385 
2386         // ensure emergency exit is active
2387         EmergencyExitStatus memory status = emergencyExitStatusOfVault[vault];
2388         if (!status.activated) {
2389             revert Error_EmergencyExitNotActivated();
2390         }
2391 
2392         /// -----------------------------------------------------------------------
2393         /// State updates
2394         /// -----------------------------------------------------------------------
2395 
2396         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2397         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
2398 
2399         // accrue yield
2400         _accrueYield(vault, pyt, msg.sender, updatedPricePerVaultShare);
2401 
2402         // burn NYT from the sender
2403         NegativeYieldToken nyt = getNegativeYieldTokenForVault(vault);
2404         nyt.gateBurn(msg.sender, amount);
2405 
2406         /// -----------------------------------------------------------------------
2407         /// Effects
2408         /// -----------------------------------------------------------------------
2409 
2410         // compute how much of the underlying assets to give the recipient
2411         // rounds down
2412         underlyingAmount = FullMath.mulDiv(
2413             amount,
2414             PRECISION - status.pytPriceInUnderlying,
2415             PRECISION
2416         );
2417 
2418         // withdraw underlying from vault to recipient
2419         // don't check balance since user can just withdraw slightly less
2420         // saves gas this way
2421         underlyingAmount = _withdrawFromVault(
2422             recipient,
2423             vault,
2424             underlyingAmount,
2425             updatedPricePerVaultShare,
2426             false
2427         );
2428     }
2429 
2430     /// @notice Emergency exit PYTs into the underlying asset. Only callable when emergency exit has
2431     /// been activated for the vault.
2432     /// @param vault The vault to exit PYT for
2433     /// @param xPYT The xPYT contract to use for burning PYT. Set to 0 to burn raw PYT instead.
2434     /// @param amount The amount of PYT to exit
2435     /// @param recipient The recipient of the underlying asset
2436     /// @return underlyingAmount The amount of underlying asset exited
2437     function emergencyExitPerpetualYieldToken(
2438         address vault,
2439         IxPYT xPYT,
2440         uint256 amount,
2441         address recipient
2442     ) external virtual returns (uint256 underlyingAmount) {
2443         /// -----------------------------------------------------------------------
2444         /// Validation
2445         /// -----------------------------------------------------------------------
2446 
2447         // ensure emergency exit is active
2448         EmergencyExitStatus memory status = emergencyExitStatusOfVault[vault];
2449         if (!status.activated) {
2450             revert Error_EmergencyExitNotActivated();
2451         }
2452 
2453         /// -----------------------------------------------------------------------
2454         /// State updates
2455         /// -----------------------------------------------------------------------
2456 
2457         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2458         uint256 updatedPricePerVaultShare = getPricePerVaultShare(vault);
2459 
2460         // accrue yield
2461         _accrueYield(vault, pyt, msg.sender, updatedPricePerVaultShare);
2462 
2463         if (address(xPYT) == address(0)) {
2464             // burn raw PYT from sender
2465             pyt.gateBurn(msg.sender, amount);
2466         } else {
2467             /// -----------------------------------------------------------------------
2468             /// Effects
2469             /// -----------------------------------------------------------------------
2470 
2471             // convert xPYT to PYT then burn
2472             xPYT.withdraw(amount, address(this), msg.sender);
2473             pyt.gateBurn(address(this), amount);
2474         }
2475 
2476         /// -----------------------------------------------------------------------
2477         /// Effects
2478         /// -----------------------------------------------------------------------
2479 
2480         // compute how much of the underlying assets to give the recipient
2481         // rounds down
2482         underlyingAmount = FullMath.mulDiv(
2483             amount,
2484             status.pytPriceInUnderlying,
2485             PRECISION
2486         );
2487 
2488         // withdraw underlying from vault to recipient
2489         // don't check balance since user can just withdraw slightly less
2490         // saves gas this way
2491         underlyingAmount = _withdrawFromVault(
2492             recipient,
2493             vault,
2494             underlyingAmount,
2495             updatedPricePerVaultShare,
2496             false
2497         );
2498     }
2499 
2500     /// -----------------------------------------------------------------------
2501     /// Internal utilities
2502     /// -----------------------------------------------------------------------
2503 
2504     /// @dev Updates the yield earned globally and for a particular user.
2505     function _accrueYield(
2506         address vault,
2507         PerpetualYieldToken pyt,
2508         address user,
2509         uint256 updatedPricePerVaultShare
2510     ) internal virtual {
2511         uint256 updatedYieldPerToken = _computeYieldPerToken(
2512             vault,
2513             pyt,
2514             updatedPricePerVaultShare
2515         );
2516         uint256 userYieldPerTokenStored_ = userYieldPerTokenStored[vault][user];
2517         if (userYieldPerTokenStored_ != 0) {
2518             userAccruedYield[vault][user] =
2519                 _getClaimableYieldAmount(
2520                     vault,
2521                     user,
2522                     updatedYieldPerToken,
2523                     userYieldPerTokenStored_,
2524                     pyt.balanceOf(user)
2525                 ) +
2526                 1;
2527         }
2528         yieldPerTokenStored[vault] = updatedYieldPerToken;
2529         pricePerVaultShareStored[vault] = updatedPricePerVaultShare;
2530         userYieldPerTokenStored[vault][user] = updatedYieldPerToken + 1;
2531     }
2532 
2533     /// @dev Mints PYTs and NYTs to the recipient given the amount of underlying deposited.
2534     function _enter(
2535         address nytRecipient,
2536         address pytRecipient,
2537         address vault,
2538         IxPYT xPYT,
2539         uint256 underlyingAmount,
2540         uint256 updatedPricePerVaultShare
2541     ) internal virtual {
2542         NegativeYieldToken nyt = getNegativeYieldTokenForVault(vault);
2543         if (address(nyt).code.length == 0) {
2544             // token pair hasn't been deployed yet
2545             // do the deployment now
2546             // only need to check nyt since nyt and pyt are always deployed in pairs
2547             factory.deployYieldTokenPair(this, vault);
2548         }
2549         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2550 
2551         /// -----------------------------------------------------------------------
2552         /// State updates
2553         /// -----------------------------------------------------------------------
2554 
2555         // accrue yield
2556         _accrueYield(
2557             vault,
2558             pyt,
2559             address(xPYT) == address(0) ? pytRecipient : address(xPYT),
2560             updatedPricePerVaultShare
2561         );
2562 
2563         // mint NYTs and PYTs
2564         nyt.gateMint(nytRecipient, underlyingAmount);
2565         if (address(xPYT) == address(0)) {
2566             // mint raw PYT to recipient
2567             pyt.gateMint(pytRecipient, underlyingAmount);
2568         } else {
2569             // mint PYT to xPYT contract
2570             pyt.gateMint(address(xPYT), underlyingAmount);
2571 
2572             /// -----------------------------------------------------------------------
2573             /// Effects
2574             /// -----------------------------------------------------------------------
2575 
2576             // call sweep to mint xPYT using the PYT
2577             xPYT.sweep(pytRecipient);
2578         }
2579     }
2580 
2581     /// @dev Burns PYTs and NYTs from msg.sender given the amount of underlying withdrawn.
2582     function _exit(
2583         address vault,
2584         IxPYT xPYT,
2585         uint256 underlyingAmount,
2586         uint256 updatedPricePerVaultShare
2587     ) internal virtual {
2588         NegativeYieldToken nyt = getNegativeYieldTokenForVault(vault);
2589         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2590         if (address(nyt).code.length == 0) {
2591             revert Error_TokenPairNotDeployed();
2592         }
2593 
2594         /// -----------------------------------------------------------------------
2595         /// State updates
2596         /// -----------------------------------------------------------------------
2597 
2598         // accrue yield
2599         _accrueYield(
2600             vault,
2601             pyt,
2602             address(xPYT) == address(0) ? msg.sender : address(this),
2603             updatedPricePerVaultShare
2604         );
2605 
2606         // burn NYTs and PYTs
2607         nyt.gateBurn(msg.sender, underlyingAmount);
2608         if (address(xPYT) == address(0)) {
2609             // burn raw PYT from sender
2610             pyt.gateBurn(msg.sender, underlyingAmount);
2611         } else {
2612             /// -----------------------------------------------------------------------
2613             /// Effects
2614             /// -----------------------------------------------------------------------
2615 
2616             // convert xPYT to PYT then burn
2617             xPYT.withdraw(underlyingAmount, address(this), msg.sender);
2618             pyt.gateBurn(address(this), underlyingAmount);
2619         }
2620     }
2621 
2622     /// @dev Updates storage variables for when a PYT holder claims the accrued yield.
2623     function _claimYield(address vault, uint256 updatedPricePerVaultShare)
2624         internal
2625         virtual
2626         returns (uint256 yieldAmount)
2627     {
2628         /// -----------------------------------------------------------------------
2629         /// Validation
2630         /// -----------------------------------------------------------------------
2631 
2632         PerpetualYieldToken pyt = getPerpetualYieldTokenForVault(vault);
2633         if (address(pyt).code.length == 0) {
2634             revert Error_TokenPairNotDeployed();
2635         }
2636 
2637         /// -----------------------------------------------------------------------
2638         /// State updates
2639         /// -----------------------------------------------------------------------
2640 
2641         // accrue yield
2642         uint256 updatedYieldPerToken = _computeYieldPerToken(
2643             vault,
2644             pyt,
2645             updatedPricePerVaultShare
2646         );
2647         uint256 userYieldPerTokenStored_ = userYieldPerTokenStored[vault][
2648             msg.sender
2649         ];
2650         if (userYieldPerTokenStored_ != 0) {
2651             yieldAmount = _getClaimableYieldAmount(
2652                 vault,
2653                 msg.sender,
2654                 updatedYieldPerToken,
2655                 userYieldPerTokenStored_,
2656                 pyt.balanceOf(msg.sender)
2657             );
2658         }
2659         yieldPerTokenStored[vault] = updatedYieldPerToken;
2660         pricePerVaultShareStored[vault] = updatedPricePerVaultShare;
2661         userYieldPerTokenStored[vault][msg.sender] = updatedYieldPerToken + 1;
2662         if (yieldAmount != 0) {
2663             userAccruedYield[vault][msg.sender] = 1;
2664         }
2665     }
2666 
2667     /// @dev Returns the amount of yield claimable by a PerpetualYieldToken holder from a vault.
2668     /// Assumes userYieldPerTokenStored_ != 0. Does not account for protocol fees.
2669     function _getClaimableYieldAmount(
2670         address vault,
2671         address user,
2672         uint256 updatedYieldPerToken,
2673         uint256 userYieldPerTokenStored_,
2674         uint256 userPYTBalance
2675     ) internal view virtual returns (uint256 yieldAmount) {
2676         unchecked {
2677             // the stored value is shifted by one
2678             uint256 actualUserYieldPerToken = userYieldPerTokenStored_ - 1;
2679 
2680             // updatedYieldPerToken - actualUserYieldPerToken won't underflow since we check updatedYieldPerToken > actualUserYieldPerToken
2681             yieldAmount = FullMath.mulDiv(
2682                 userPYTBalance,
2683                 updatedYieldPerToken > actualUserYieldPerToken
2684                     ? updatedYieldPerToken - actualUserYieldPerToken
2685                     : 0,
2686                 PRECISION
2687             );
2688 
2689             uint256 accruedYield = userAccruedYield[vault][user];
2690             if (accruedYield > 1) {
2691                 // won't overflow since the sum is at most the totalSupply of the vault's underlying, which
2692                 // is at most 256 bits.
2693                 // the stored accruedYield value is shifted by one
2694                 yieldAmount += accruedYield - 1;
2695             }
2696         }
2697     }
2698 
2699     /// @dev Deposits underlying tokens into a vault
2700     /// @param underlying The underlying token to deposit
2701     /// @param underlyingAmount The amount of tokens to deposit
2702     /// @param vault The vault to deposit into
2703     function _depositIntoVault(
2704         ERC20 underlying,
2705         uint256 underlyingAmount,
2706         address vault
2707     ) internal virtual;
2708 
2709     /// @dev Withdraws underlying tokens from a vault
2710     /// @param recipient The recipient of the underlying tokens
2711     /// @param vault The vault to withdraw from
2712     /// @param underlyingAmount The amount of tokens to withdraw
2713     /// @param pricePerVaultShare The latest price per vault share value
2714     /// @param checkBalance Set to true to withdraw the entire balance if we're trying
2715     /// to withdraw more than the balance (due to rounding errors)
2716     /// @return withdrawnUnderlyingAmount The amount of underlying tokens withdrawn
2717     function _withdrawFromVault(
2718         address recipient,
2719         address vault,
2720         uint256 underlyingAmount,
2721         uint256 pricePerVaultShare,
2722         bool checkBalance
2723     ) internal virtual returns (uint256 withdrawnUnderlyingAmount);
2724 
2725     /// @dev Converts a vault share amount into an equivalent underlying asset amount
2726     function _vaultSharesAmountToUnderlyingAmount(
2727         address vault,
2728         uint256 vaultSharesAmount,
2729         uint256 pricePerVaultShare
2730     ) internal view virtual returns (uint256);
2731 
2732     /// @dev Converts a vault share amount into an equivalent underlying asset amount, rounding up
2733     function _vaultSharesAmountToUnderlyingAmountRoundingUp(
2734         address vault,
2735         uint256 vaultSharesAmount,
2736         uint256 pricePerVaultShare
2737     ) internal view virtual returns (uint256);
2738 
2739     /// @dev Converts an underlying asset amount into an equivalent vault shares amount
2740     function _underlyingAmountToVaultSharesAmount(
2741         address vault,
2742         uint256 underlyingAmount,
2743         uint256 pricePerVaultShare
2744     ) internal view virtual returns (uint256);
2745 
2746     /// @dev Computes the latest yieldPerToken value for a vault.
2747     function _computeYieldPerToken(
2748         address vault,
2749         PerpetualYieldToken pyt,
2750         uint256 updatedPricePerVaultShare
2751     ) internal view virtual returns (uint256) {
2752         uint256 pytTotalSupply = pyt.totalSupply();
2753         if (pytTotalSupply == 0) {
2754             return yieldPerTokenStored[vault];
2755         }
2756         uint256 pricePerVaultShareStored_ = pricePerVaultShareStored[vault];
2757         if (updatedPricePerVaultShare <= pricePerVaultShareStored_) {
2758             // rounding error in vault share or no yield accrued
2759             return yieldPerTokenStored[vault];
2760         }
2761         uint256 newYieldPerTokenAccrued;
2762         unchecked {
2763             // can't underflow since we know updatedPricePerVaultShare > pricePerVaultShareStored_
2764             newYieldPerTokenAccrued = FullMath.mulDiv(
2765                 updatedPricePerVaultShare - pricePerVaultShareStored_,
2766                 getVaultShareBalance(vault),
2767                 pytTotalSupply
2768             );
2769         }
2770         return yieldPerTokenStored[vault] + newYieldPerTokenAccrued;
2771     }
2772 }
2773 
2774 /// @title Safe casting methods
2775 /// @notice Contains methods for safely casting between types
2776 library SafeCast {
2777     /// @notice Cast a uint256 to a uint160, revert on overflow
2778     /// @param y The uint256 to be downcasted
2779     /// @return z The downcasted integer, now type uint160
2780     function toUint160(uint256 y) internal pure returns (uint160 z) {
2781         require((z = uint160(y)) == y);
2782     }
2783 
2784     /// @notice Cast a int256 to a int128, revert on overflow or underflow
2785     /// @param y The int256 to be downcasted
2786     /// @return z The downcasted integer, now type int128
2787     function toInt128(int256 y) internal pure returns (int128 z) {
2788         require((z = int128(y)) == y);
2789     }
2790 
2791     /// @notice Cast a uint256 to a int256, revert on overflow
2792     /// @param y The uint256 to be casted
2793     /// @return z The casted integer, now type int256
2794     function toInt256(uint256 y) internal pure returns (int256 z) {
2795         require(y < 2**255);
2796         z = int256(y);
2797     }
2798 }
2799 
2800 /// @title Pool state that never changes
2801 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
2802 interface IUniswapV3PoolImmutables {
2803     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
2804     /// @return The contract address
2805     function factory() external view returns (address);
2806 
2807     /// @notice The first of the two tokens of the pool, sorted by address
2808     /// @return The token contract address
2809     function token0() external view returns (address);
2810 
2811     /// @notice The second of the two tokens of the pool, sorted by address
2812     /// @return The token contract address
2813     function token1() external view returns (address);
2814 
2815     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
2816     /// @return The fee
2817     function fee() external view returns (uint24);
2818 
2819     /// @notice The pool tick spacing
2820     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
2821     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
2822     /// This value is an int24 to avoid casting even though it is always positive.
2823     /// @return The tick spacing
2824     function tickSpacing() external view returns (int24);
2825 
2826     /// @notice The maximum amount of position liquidity that can use any tick in the range
2827     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
2828     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
2829     /// @return The max amount of liquidity per tick
2830     function maxLiquidityPerTick() external view returns (uint128);
2831 }
2832 
2833 /// @title Pool state that can change
2834 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
2835 /// per transaction
2836 interface IUniswapV3PoolState {
2837     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
2838     /// when accessed externally.
2839     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
2840     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
2841     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
2842     /// boundary.
2843     /// observationIndex The index of the last oracle observation that was written,
2844     /// observationCardinality The current maximum number of observations stored in the pool,
2845     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
2846     /// feeProtocol The protocol fee for both tokens of the pool.
2847     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
2848     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
2849     /// unlocked Whether the pool is currently locked to reentrancy
2850     function slot0()
2851         external
2852         view
2853         returns (
2854             uint160 sqrtPriceX96,
2855             int24 tick,
2856             uint16 observationIndex,
2857             uint16 observationCardinality,
2858             uint16 observationCardinalityNext,
2859             uint8 feeProtocol,
2860             bool unlocked
2861         );
2862 
2863     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
2864     /// @dev This value can overflow the uint256
2865     function feeGrowthGlobal0X128() external view returns (uint256);
2866 
2867     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
2868     /// @dev This value can overflow the uint256
2869     function feeGrowthGlobal1X128() external view returns (uint256);
2870 
2871     /// @notice The amounts of token0 and token1 that are owed to the protocol
2872     /// @dev Protocol fees will never exceed uint128 max in either token
2873     function protocolFees() external view returns (uint128 token0, uint128 token1);
2874 
2875     /// @notice The currently in range liquidity available to the pool
2876     /// @dev This value has no relationship to the total liquidity across all ticks
2877     function liquidity() external view returns (uint128);
2878 
2879     /// @notice Look up information about a specific tick in the pool
2880     /// @param tick The tick to look up
2881     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
2882     /// tick upper,
2883     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
2884     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
2885     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
2886     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
2887     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
2888     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
2889     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
2890     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
2891     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
2892     /// a specific position.
2893     function ticks(int24 tick)
2894         external
2895         view
2896         returns (
2897             uint128 liquidityGross,
2898             int128 liquidityNet,
2899             uint256 feeGrowthOutside0X128,
2900             uint256 feeGrowthOutside1X128,
2901             int56 tickCumulativeOutside,
2902             uint160 secondsPerLiquidityOutsideX128,
2903             uint32 secondsOutside,
2904             bool initialized
2905         );
2906 
2907     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
2908     function tickBitmap(int16 wordPosition) external view returns (uint256);
2909 
2910     /// @notice Returns the information about a position by the position's key
2911     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
2912     /// @return _liquidity The amount of liquidity in the position,
2913     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
2914     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
2915     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
2916     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
2917     function positions(bytes32 key)
2918         external
2919         view
2920         returns (
2921             uint128 _liquidity,
2922             uint256 feeGrowthInside0LastX128,
2923             uint256 feeGrowthInside1LastX128,
2924             uint128 tokensOwed0,
2925             uint128 tokensOwed1
2926         );
2927 
2928     /// @notice Returns data about a specific observation index
2929     /// @param index The element of the observations array to fetch
2930     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
2931     /// ago, rather than at a specific index in the array.
2932     /// @return blockTimestamp The timestamp of the observation,
2933     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
2934     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
2935     /// Returns initialized whether the observation has been initialized and the values are safe to use
2936     function observations(uint256 index)
2937         external
2938         view
2939         returns (
2940             uint32 blockTimestamp,
2941             int56 tickCumulative,
2942             uint160 secondsPerLiquidityCumulativeX128,
2943             bool initialized
2944         );
2945 }
2946 
2947 /// @title Pool state that is not stored
2948 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
2949 /// blockchain. The functions here may have variable gas costs.
2950 interface IUniswapV3PoolDerivedState {
2951     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
2952     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
2953     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
2954     /// you must call it with secondsAgos = [3600, 0].
2955     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
2956     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
2957     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
2958     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
2959     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
2960     /// timestamp
2961     function observe(uint32[] calldata secondsAgos)
2962         external
2963         view
2964         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
2965 
2966     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
2967     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
2968     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
2969     /// snapshot is taken and the second snapshot is taken.
2970     /// @param tickLower The lower tick of the range
2971     /// @param tickUpper The upper tick of the range
2972     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
2973     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
2974     /// @return secondsInside The snapshot of seconds per liquidity for the range
2975     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
2976         external
2977         view
2978         returns (
2979             int56 tickCumulativeInside,
2980             uint160 secondsPerLiquidityInsideX128,
2981             uint32 secondsInside
2982         );
2983 }
2984 
2985 /// @title Permissionless pool actions
2986 /// @notice Contains pool methods that can be called by anyone
2987 interface IUniswapV3PoolActions {
2988     /// @notice Sets the initial price for the pool
2989     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
2990     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
2991     function initialize(uint160 sqrtPriceX96) external;
2992 
2993     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
2994     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
2995     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
2996     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
2997     /// @param recipient The address for which the liquidity will be created
2998     /// @param tickLower The lower tick of the position in which to add liquidity
2999     /// @param tickUpper The upper tick of the position in which to add liquidity
3000     /// @param amount The amount of liquidity to mint
3001     /// @param data Any data that should be passed through to the callback
3002     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
3003     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
3004     function mint(
3005         address recipient,
3006         int24 tickLower,
3007         int24 tickUpper,
3008         uint128 amount,
3009         bytes calldata data
3010     ) external returns (uint256 amount0, uint256 amount1);
3011 
3012     /// @notice Collects tokens owed to a position
3013     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
3014     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
3015     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
3016     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
3017     /// @param recipient The address which should receive the fees collected
3018     /// @param tickLower The lower tick of the position for which to collect fees
3019     /// @param tickUpper The upper tick of the position for which to collect fees
3020     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
3021     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
3022     /// @return amount0 The amount of fees collected in token0
3023     /// @return amount1 The amount of fees collected in token1
3024     function collect(
3025         address recipient,
3026         int24 tickLower,
3027         int24 tickUpper,
3028         uint128 amount0Requested,
3029         uint128 amount1Requested
3030     ) external returns (uint128 amount0, uint128 amount1);
3031 
3032     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
3033     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
3034     /// @dev Fees must be collected separately via a call to #collect
3035     /// @param tickLower The lower tick of the position for which to burn liquidity
3036     /// @param tickUpper The upper tick of the position for which to burn liquidity
3037     /// @param amount How much liquidity to burn
3038     /// @return amount0 The amount of token0 sent to the recipient
3039     /// @return amount1 The amount of token1 sent to the recipient
3040     function burn(
3041         int24 tickLower,
3042         int24 tickUpper,
3043         uint128 amount
3044     ) external returns (uint256 amount0, uint256 amount1);
3045 
3046     /// @notice Swap token0 for token1, or token1 for token0
3047     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
3048     /// @param recipient The address to receive the output of the swap
3049     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
3050     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
3051     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
3052     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
3053     /// @param data Any data to be passed through to the callback
3054     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
3055     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
3056     function swap(
3057         address recipient,
3058         bool zeroForOne,
3059         int256 amountSpecified,
3060         uint160 sqrtPriceLimitX96,
3061         bytes calldata data
3062     ) external returns (int256 amount0, int256 amount1);
3063 
3064     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
3065     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
3066     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
3067     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
3068     /// @param recipient The address which will receive the token0 and token1 amounts
3069     /// @param amount0 The amount of token0 to send
3070     /// @param amount1 The amount of token1 to send
3071     /// @param data Any data to be passed through to the callback
3072     function flash(
3073         address recipient,
3074         uint256 amount0,
3075         uint256 amount1,
3076         bytes calldata data
3077     ) external;
3078 
3079     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
3080     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
3081     /// the input observationCardinalityNext.
3082     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
3083     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
3084 }
3085 
3086 /// @title Permissioned pool actions
3087 /// @notice Contains pool methods that may only be called by the factory owner
3088 interface IUniswapV3PoolOwnerActions {
3089     /// @notice Set the denominator of the protocol's % share of the fees
3090     /// @param feeProtocol0 new protocol fee for token0 of the pool
3091     /// @param feeProtocol1 new protocol fee for token1 of the pool
3092     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
3093 
3094     /// @notice Collect the protocol fee accrued to the pool
3095     /// @param recipient The address to which collected protocol fees should be sent
3096     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
3097     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
3098     /// @return amount0 The protocol fee collected in token0
3099     /// @return amount1 The protocol fee collected in token1
3100     function collectProtocol(
3101         address recipient,
3102         uint128 amount0Requested,
3103         uint128 amount1Requested
3104     ) external returns (uint128 amount0, uint128 amount1);
3105 }
3106 
3107 /// @title Events emitted by a pool
3108 /// @notice Contains all events emitted by the pool
3109 interface IUniswapV3PoolEvents {
3110     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
3111     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
3112     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
3113     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
3114     event Initialize(uint160 sqrtPriceX96, int24 tick);
3115 
3116     /// @notice Emitted when liquidity is minted for a given position
3117     /// @param sender The address that minted the liquidity
3118     /// @param owner The owner of the position and recipient of any minted liquidity
3119     /// @param tickLower The lower tick of the position
3120     /// @param tickUpper The upper tick of the position
3121     /// @param amount The amount of liquidity minted to the position range
3122     /// @param amount0 How much token0 was required for the minted liquidity
3123     /// @param amount1 How much token1 was required for the minted liquidity
3124     event Mint(
3125         address sender,
3126         address indexed owner,
3127         int24 indexed tickLower,
3128         int24 indexed tickUpper,
3129         uint128 amount,
3130         uint256 amount0,
3131         uint256 amount1
3132     );
3133 
3134     /// @notice Emitted when fees are collected by the owner of a position
3135     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
3136     /// @param owner The owner of the position for which fees are collected
3137     /// @param tickLower The lower tick of the position
3138     /// @param tickUpper The upper tick of the position
3139     /// @param amount0 The amount of token0 fees collected
3140     /// @param amount1 The amount of token1 fees collected
3141     event Collect(
3142         address indexed owner,
3143         address recipient,
3144         int24 indexed tickLower,
3145         int24 indexed tickUpper,
3146         uint128 amount0,
3147         uint128 amount1
3148     );
3149 
3150     /// @notice Emitted when a position's liquidity is removed
3151     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
3152     /// @param owner The owner of the position for which liquidity is removed
3153     /// @param tickLower The lower tick of the position
3154     /// @param tickUpper The upper tick of the position
3155     /// @param amount The amount of liquidity to remove
3156     /// @param amount0 The amount of token0 withdrawn
3157     /// @param amount1 The amount of token1 withdrawn
3158     event Burn(
3159         address indexed owner,
3160         int24 indexed tickLower,
3161         int24 indexed tickUpper,
3162         uint128 amount,
3163         uint256 amount0,
3164         uint256 amount1
3165     );
3166 
3167     /// @notice Emitted by the pool for any swaps between token0 and token1
3168     /// @param sender The address that initiated the swap call, and that received the callback
3169     /// @param recipient The address that received the output of the swap
3170     /// @param amount0 The delta of the token0 balance of the pool
3171     /// @param amount1 The delta of the token1 balance of the pool
3172     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
3173     /// @param liquidity The liquidity of the pool after the swap
3174     /// @param tick The log base 1.0001 of price of the pool after the swap
3175     event Swap(
3176         address indexed sender,
3177         address indexed recipient,
3178         int256 amount0,
3179         int256 amount1,
3180         uint160 sqrtPriceX96,
3181         uint128 liquidity,
3182         int24 tick
3183     );
3184 
3185     /// @notice Emitted by the pool for any flashes of token0/token1
3186     /// @param sender The address that initiated the swap call, and that received the callback
3187     /// @param recipient The address that received the tokens from flash
3188     /// @param amount0 The amount of token0 that was flashed
3189     /// @param amount1 The amount of token1 that was flashed
3190     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
3191     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
3192     event Flash(
3193         address indexed sender,
3194         address indexed recipient,
3195         uint256 amount0,
3196         uint256 amount1,
3197         uint256 paid0,
3198         uint256 paid1
3199     );
3200 
3201     /// @notice Emitted by the pool for increases to the number of observations that can be stored
3202     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
3203     /// just before a mint/swap/burn.
3204     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
3205     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
3206     event IncreaseObservationCardinalityNext(
3207         uint16 observationCardinalityNextOld,
3208         uint16 observationCardinalityNextNew
3209     );
3210 
3211     /// @notice Emitted when the protocol fee is changed by the pool
3212     /// @param feeProtocol0Old The previous value of the token0 protocol fee
3213     /// @param feeProtocol1Old The previous value of the token1 protocol fee
3214     /// @param feeProtocol0New The updated value of the token0 protocol fee
3215     /// @param feeProtocol1New The updated value of the token1 protocol fee
3216     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
3217 
3218     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
3219     /// @param sender The address that collects the protocol fees
3220     /// @param recipient The address that receives the collected protocol fees
3221     /// @param amount0 The amount of token0 protocol fees that is withdrawn
3222     /// @param amount0 The amount of token1 protocol fees that is withdrawn
3223     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
3224 }
3225 
3226 /// @title The interface for a Uniswap V3 Pool
3227 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
3228 /// to the ERC20 specification
3229 /// @dev The pool interface is broken up into many smaller pieces
3230 interface IUniswapV3Pool is
3231     IUniswapV3PoolImmutables,
3232     IUniswapV3PoolState,
3233     IUniswapV3PoolDerivedState,
3234     IUniswapV3PoolActions,
3235     IUniswapV3PoolOwnerActions,
3236     IUniswapV3PoolEvents
3237 {
3238 
3239 }
3240 
3241 /// @title Callback for IUniswapV3PoolActions#swap
3242 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
3243 interface IUniswapV3SwapCallback {
3244     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
3245     /// @dev In the implementation you must pay the pool tokens owed for the swap.
3246     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
3247     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
3248     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
3249     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
3250     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
3251     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
3252     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
3253     function uniswapV3SwapCallback(
3254         int256 amount0Delta,
3255         int256 amount1Delta,
3256         bytes calldata data
3257     ) external;
3258 }
3259 
3260 /// @title Swapper
3261 /// @author zefram.eth
3262 /// @notice Abstract contract for swapping between xPYTs/NYTs and their underlying asset by
3263 /// swapping via an external DEX and minting/burning xPYT/NYT.
3264 /// @dev Swapper supports two-hop swaps where one of the swaps is an 0x swap between two regular tokens,
3265 /// which enables swapping any supported token into any xPYT/NYT. Two-hop swaps are done by chaining
3266 /// two calls together via Multicall and setting the recipient of the first swap to the Swapper.
3267 abstract contract Swapper is
3268     Multicall,
3269     SelfPermit,
3270     ReentrancyGuard,
3271     BoringOwnable
3272 {
3273     /// -----------------------------------------------------------------------
3274     /// Library usage
3275     /// -----------------------------------------------------------------------
3276 
3277     using SafeTransferLib for ERC20;
3278 
3279     /// -----------------------------------------------------------------------
3280     /// Errors
3281     /// -----------------------------------------------------------------------
3282 
3283     error Error_SameToken();
3284     error Error_PastDeadline();
3285     error Error_ZeroExSwapFailed();
3286     error Error_InsufficientOutput();
3287     error Error_ProtocolFeeRecipientIsZero();
3288 
3289     /// -----------------------------------------------------------------------
3290     /// Events
3291     /// -----------------------------------------------------------------------
3292 
3293     event SetProtocolFee(ProtocolFeeInfo protocolFeeInfo_);
3294 
3295     /// -----------------------------------------------------------------------
3296     /// Structs
3297     /// -----------------------------------------------------------------------
3298 
3299     /// @param gate The Gate used by the xPYT/NYT
3300     /// @param vault The yield-bearing vault used by the xPYT/NYT
3301     /// @param underlying The underlying asset of the xPYT/NYT
3302     /// @param nyt The NYT contract linked to the xPYT/NYT being swapped
3303     /// @param pyt The PYT contract linked to the xPYT/NYT being swapped
3304     /// @param xPYT The xPYT contract linked to the xPYT/NYT being swapped
3305     /// @param tokenAmountIn The amount of token input
3306     /// @param minAmountOut The minimum acceptable token output amount, used for slippage checking.
3307     /// @param recipient The recipient of the token output
3308     /// @param useSwapperBalance Set to true to use the Swapper's token balance as token input, in which
3309     /// case `tokenAmountIn` will be overriden to the balance.
3310     /// @param usePYT Set to true to use raw PYT as the input/output token instead of xPYT. Ignored
3311     /// when swapping from the underlying to NYT.
3312     /// @param deadline The Unix timestamp (in seconds) after which the call will be reverted
3313     /// @param extraArgs Used for providing extra input parameters for different protocols/use cases
3314     struct SwapArgs {
3315         Gate gate;
3316         address vault;
3317         ERC20 underlying;
3318         ERC20 nyt;
3319         ERC20 pyt;
3320         IxPYT xPYT;
3321         uint256 tokenAmountIn;
3322         uint256 minAmountOut;
3323         address recipient;
3324         bool useSwapperBalance;
3325         bool usePYT;
3326         uint256 deadline;
3327         bytes extraArgs;
3328     }
3329 
3330     /// @param fee The fee value. Each increment represents 0.01%, so max is 2.55% (8 bits)
3331     /// @param recipient The address that will receive the protocol fees
3332     struct ProtocolFeeInfo {
3333         uint8 fee;
3334         address recipient;
3335     }
3336 
3337     /// -----------------------------------------------------------------------
3338     /// Immutable parameters
3339     /// -----------------------------------------------------------------------
3340 
3341     /// @notice The 0x proxy contract used for 0x swaps
3342     address public immutable zeroExProxy;
3343 
3344     /// @notice The Wrapped Ethereum contract
3345     WETH public immutable weth;
3346 
3347     /// -----------------------------------------------------------------------
3348     /// Storage variables
3349     /// -----------------------------------------------------------------------
3350 
3351     /// @notice The protocol fee and the fee recipient address.
3352     ProtocolFeeInfo public protocolFeeInfo;
3353 
3354     /// -----------------------------------------------------------------------
3355     /// Constructor
3356     /// -----------------------------------------------------------------------
3357 
3358     constructor(
3359         address zeroExProxy_,
3360         WETH weth_,
3361         ProtocolFeeInfo memory protocolFeeInfo_
3362     ) {
3363         zeroExProxy = zeroExProxy_;
3364         weth = weth_;
3365 
3366         if (
3367             protocolFeeInfo_.fee != 0 &&
3368             protocolFeeInfo_.recipient == address(0)
3369         ) {
3370             revert Error_ProtocolFeeRecipientIsZero();
3371         }
3372         protocolFeeInfo = protocolFeeInfo_;
3373         emit SetProtocolFee(protocolFeeInfo_);
3374     }
3375 
3376     /// -----------------------------------------------------------------------
3377     /// Swaps
3378     /// -----------------------------------------------------------------------
3379 
3380     /// @notice Swaps the underlying asset of an NYT into the NYT
3381     /// @param args The input arguments (see SwapArgs definition)
3382     /// @return tokenAmountOut The amount of token output
3383     function swapUnderlyingToNyt(SwapArgs calldata args)
3384         external
3385         payable
3386         virtual
3387         returns (uint256 tokenAmountOut);
3388 
3389     /// @notice Swaps the underlying asset of an xPYT into the xPYT
3390     /// @param args The input arguments (see SwapArgs definition)
3391     /// @return tokenAmountOut The amount of token output
3392     function swapUnderlyingToXpyt(SwapArgs calldata args)
3393         external
3394         payable
3395         virtual
3396         returns (uint256 tokenAmountOut);
3397 
3398     /// @notice Swaps an NYT to its underlying asset
3399     /// @param args The input arguments (see SwapArgs definition)
3400     /// @return tokenAmountOut The amount of token output
3401     function swapNytToUnderlying(SwapArgs calldata args)
3402         external
3403         payable
3404         virtual
3405         returns (uint256 tokenAmountOut);
3406 
3407     /// @notice Swaps an xPYT to its underlying asset
3408     /// @param args The input arguments (see SwapArgs definition)
3409     /// @return tokenAmountOut The amount of token output
3410     function swapXpytToUnderlying(SwapArgs calldata args)
3411         external
3412         payable
3413         virtual
3414         returns (uint256 tokenAmountOut);
3415 
3416     /// -----------------------------------------------------------------------
3417     /// 0x support
3418     /// -----------------------------------------------------------------------
3419 
3420     /// @notice Swaps between two regular tokens using 0x.
3421     /// @dev Used in conjuction with the 0x API https://www.0x.org/docs/api
3422     /// @param tokenIn The input token
3423     /// @param tokenAmountIn The amount of token input
3424     /// @param tokenOut The output token
3425     /// @param minAmountOut The minimum acceptable token output amount, used for slippage checking.
3426     /// @param recipient The recipient of the token output
3427     /// @param useSwapperBalance Set to true to use the Swapper's token balance as token input
3428     /// @param requireApproval Set to true to approve tokenIn to zeroExProxy
3429     /// @param deadline The Unix timestamp (in seconds) after which the call will be reverted
3430     /// @param swapData The call data to zeroExProxy to execute the swap, obtained from
3431     /// the https://api.0x.org/swap/v1/quote endpoint
3432     /// @return tokenAmountOut The amount of token output
3433     function doZeroExSwap(
3434         ERC20 tokenIn,
3435         uint256 tokenAmountIn,
3436         ERC20 tokenOut,
3437         uint256 minAmountOut,
3438         address recipient,
3439         bool useSwapperBalance,
3440         bool requireApproval,
3441         uint256 deadline,
3442         bytes calldata swapData
3443     ) external payable virtual nonReentrant returns (uint256 tokenAmountOut) {
3444         // check if input token equals output
3445         if (tokenIn == tokenOut) {
3446             revert Error_SameToken();
3447         }
3448 
3449         // check deadline
3450         if (block.timestamp > deadline) {
3451             revert Error_PastDeadline();
3452         }
3453 
3454         // transfer in input tokens
3455         if (!useSwapperBalance) {
3456             tokenIn.safeTransferFrom(msg.sender, address(this), tokenAmountIn);
3457         }
3458 
3459         // approve zeroExProxy
3460         if (requireApproval) {
3461             tokenIn.safeApprove(zeroExProxy, type(uint256).max);
3462         }
3463 
3464         // do swap via zeroExProxy
3465         (bool success, ) = zeroExProxy.call(swapData);
3466         if (!success) {
3467             revert Error_ZeroExSwapFailed();
3468         }
3469 
3470         // check slippage
3471         tokenAmountOut = tokenOut.balanceOf(address(this));
3472         if (tokenAmountOut < minAmountOut) {
3473             revert Error_InsufficientOutput();
3474         }
3475 
3476         // transfer output tokens to recipient
3477         if (recipient != address(this)) {
3478             tokenOut.safeTransfer(recipient, tokenAmountOut);
3479         }
3480     }
3481 
3482     /// -----------------------------------------------------------------------
3483     /// WETH support
3484     /// -----------------------------------------------------------------------
3485 
3486     /// @notice Wraps the user's ETH input into WETH
3487     /// @dev Should be used as part of a multicall to convert the user's ETH input into WETH
3488     /// so that it can be swapped into xPYT/NYT.
3489     function wrapEthInput() external payable {
3490         weth.deposit{value: msg.value}();
3491     }
3492 
3493     /// -----------------------------------------------------------------------
3494     /// Owner functions
3495     /// -----------------------------------------------------------------------
3496 
3497     /// @notice Updates the protocol fee and/or the protocol fee recipient.
3498     /// Only callable by the owner.
3499     /// @param protocolFeeInfo_ The new protocol fee info
3500     function ownerSetProtocolFee(ProtocolFeeInfo calldata protocolFeeInfo_)
3501         external
3502         virtual
3503         onlyOwner
3504     {
3505         if (
3506             protocolFeeInfo_.fee != 0 &&
3507             protocolFeeInfo_.recipient == address(0)
3508         ) {
3509             revert Error_ProtocolFeeRecipientIsZero();
3510         }
3511         protocolFeeInfo = protocolFeeInfo_;
3512 
3513         emit SetProtocolFee(protocolFeeInfo_);
3514     }
3515 }
3516 
3517 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
3518 library PoolAddress {
3519     using Bytes32AddressLib for bytes32;
3520 
3521     bytes32 internal constant POOL_INIT_CODE_HASH =
3522         0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
3523 
3524     /// @notice The identifying key of the pool
3525     struct PoolKey {
3526         address token0;
3527         address token1;
3528         uint24 fee;
3529     }
3530 
3531     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
3532     /// @param tokenA The first token of a pool, unsorted
3533     /// @param tokenB The second token of a pool, unsorted
3534     /// @param fee The fee level of the pool
3535     /// @return Poolkey The pool details with ordered token0 and token1 assignments
3536     function getPoolKey(
3537         address tokenA,
3538         address tokenB,
3539         uint24 fee
3540     ) internal pure returns (PoolKey memory) {
3541         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
3542         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
3543     }
3544 
3545     /// @notice Deterministically computes the pool address given the factory and PoolKey
3546     /// @param factory The Uniswap V3 factory contract address
3547     /// @param key The PoolKey
3548     /// @return pool The contract address of the V3 pool
3549     function computeAddress(address factory, PoolKey memory key)
3550         internal
3551         pure
3552         returns (address pool)
3553     {
3554         require(key.token0 < key.token1);
3555         pool = keccak256(
3556             abi.encodePacked(
3557                 hex"ff",
3558                 factory,
3559                 keccak256(abi.encode(key.token0, key.token1, key.fee)),
3560                 POOL_INIT_CODE_HASH
3561             )
3562         ).fromLast20Bytes();
3563     }
3564 }
3565 
3566 /// @title UniswapV3Swapper
3567 /// @author zefram.eth
3568 /// @notice Swapper that uses Uniswap V3 to swap between xPYTs/NYTs
3569 contract UniswapV3Swapper is Swapper, IUniswapV3SwapCallback {
3570     /// -----------------------------------------------------------------------
3571     /// Library usage
3572     /// -----------------------------------------------------------------------
3573 
3574     using SafeCast for uint256;
3575     using SafeTransferLib for ERC20;
3576     using SafeTransferLib for IxPYT;
3577 
3578     /// -----------------------------------------------------------------------
3579     /// Errors
3580     /// -----------------------------------------------------------------------
3581 
3582     error Error_NotUniswapV3Pool();
3583     error Error_BothTokenDeltasAreZero();
3584 
3585     /// -----------------------------------------------------------------------
3586     /// Structs
3587     /// -----------------------------------------------------------------------
3588 
3589     struct SwapCallbackData {
3590         ERC20 tokenIn;
3591         ERC20 tokenOut;
3592         uint24 fee;
3593     }
3594 
3595     /// -----------------------------------------------------------------------
3596     /// Constants
3597     /// -----------------------------------------------------------------------
3598 
3599     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick + 1. Equivalent to getSqrtRatioAtTick(MIN_TICK) + 1
3600     /// Copied from v3-core/libraries/TickMath.sol
3601     uint160 internal constant MIN_SQRT_RATIO_PLUS_ONE = 4295128740;
3602 
3603     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick - 1. Equivalent to getSqrtRatioAtTick(MAX_TICK) - 1
3604     /// Copied from v3-core/libraries/TickMath.sol
3605     uint160 internal constant MAX_SQRT_RATIO_MINUS_ONE =
3606         1461446703485210103287273052203988822378723970341;
3607 
3608     /// -----------------------------------------------------------------------
3609     /// Immutable parameters
3610     /// -----------------------------------------------------------------------
3611 
3612     /// @notice The official Uniswap V3 factory address
3613     address public immutable uniswapV3Factory;
3614 
3615     /// -----------------------------------------------------------------------
3616     /// Constructor
3617     /// -----------------------------------------------------------------------
3618 
3619     constructor(
3620         address zeroExProxy_,
3621         WETH weth_,
3622         ProtocolFeeInfo memory protocolFeeInfo_,
3623         address uniswapV3Factory_
3624     ) Swapper(zeroExProxy_, weth_, protocolFeeInfo_) {
3625         uniswapV3Factory = uniswapV3Factory_;
3626     }
3627 
3628     /// -----------------------------------------------------------------------
3629     /// Swaps
3630     /// -----------------------------------------------------------------------
3631 
3632     /// @inheritdoc Swapper
3633     /// @dev extraArg = (uint24 fee)
3634     /// fee: The fee tier of the Uniswap V3 pool to use
3635     function swapUnderlyingToNyt(SwapArgs calldata args)
3636         external
3637         payable
3638         virtual
3639         override
3640         nonReentrant
3641         returns (uint256 tokenAmountOut)
3642     {
3643         // check deadline
3644         if (block.timestamp > args.deadline) {
3645             revert Error_PastDeadline();
3646         }
3647 
3648         uint256 xPYTMinted;
3649         {
3650             // determine token input amount
3651             uint256 tokenAmountIn = args.useSwapperBalance
3652                 ? args.underlying.balanceOf(address(this))
3653                 : args.tokenAmountIn;
3654 
3655             // transfer underlying from sender
3656             if (!args.useSwapperBalance) {
3657                 args.underlying.safeTransferFrom(
3658                     msg.sender,
3659                     address(this),
3660                     tokenAmountIn
3661                 );
3662             }
3663 
3664             // take protocol fee
3665             ProtocolFeeInfo memory protocolFeeInfo_ = protocolFeeInfo;
3666             if (protocolFeeInfo_.fee > 0) {
3667                 uint256 feeAmount = (tokenAmountIn * protocolFeeInfo_.fee) /
3668                     10000;
3669                 if (feeAmount > 0) {
3670                     // deduct fee from token input
3671                     tokenAmountIn -= feeAmount;
3672 
3673                     // transfer fee to recipient
3674                     args.underlying.safeTransfer(
3675                         protocolFeeInfo_.recipient,
3676                         feeAmount
3677                     );
3678                 }
3679             }
3680 
3681             // add token output from minting to result
3682             tokenAmountOut = tokenAmountIn;
3683 
3684             // use underlying to mint xPYT & NYT
3685             xPYTMinted = args.xPYT.previewDeposit(tokenAmountIn);
3686             if (
3687                 args.underlying.allowance(address(this), address(args.gate)) <
3688                 tokenAmountIn
3689             ) {
3690                 args.underlying.safeApprove(
3691                     address(args.gate),
3692                     type(uint256).max
3693                 );
3694             }
3695             args.gate.enterWithUnderlying(
3696                 args.recipient, // nytRecipient
3697                 address(this), // pytRecipient
3698                 args.vault,
3699                 args.xPYT,
3700                 tokenAmountIn
3701             );
3702         }
3703 
3704         // swap xPYT to NYT
3705         {
3706             uint24 fee = abi.decode(args.extraArgs, (uint24));
3707             // swap and add swap output to result
3708             tokenAmountOut += _swap(
3709                 args.xPYT,
3710                 xPYTMinted,
3711                 args.nyt,
3712                 fee,
3713                 args.recipient
3714             );
3715         }
3716 
3717         // check slippage
3718         if (tokenAmountOut < args.minAmountOut) {
3719             revert Error_InsufficientOutput();
3720         }
3721     }
3722 
3723     /// @inheritdoc Swapper
3724     /// @dev extraArg = (uint24 fee)
3725     /// fee: The fee tier of the Uniswap V3 pool to use
3726     function swapUnderlyingToXpyt(SwapArgs calldata args)
3727         external
3728         payable
3729         virtual
3730         override
3731         nonReentrant
3732         returns (uint256 tokenAmountOut)
3733     {
3734         // check deadline
3735         if (block.timestamp > args.deadline) {
3736             revert Error_PastDeadline();
3737         }
3738 
3739         uint256 tokenAmountIn;
3740         {
3741             // determine token input and output amounts
3742             tokenAmountIn = args.useSwapperBalance
3743                 ? args.underlying.balanceOf(address(this))
3744                 : args.tokenAmountIn;
3745 
3746             // transfer underlying from sender
3747             if (!args.useSwapperBalance) {
3748                 args.underlying.safeTransferFrom(
3749                     msg.sender,
3750                     address(this),
3751                     tokenAmountIn
3752                 );
3753             }
3754 
3755             // take protocol fee
3756             ProtocolFeeInfo memory protocolFeeInfo_ = protocolFeeInfo;
3757             if (protocolFeeInfo_.fee > 0) {
3758                 uint256 feeAmount = (tokenAmountIn * protocolFeeInfo_.fee) /
3759                     10000;
3760                 if (feeAmount > 0) {
3761                     // deduct fee from token input
3762                     tokenAmountIn -= feeAmount;
3763 
3764                     // transfer fee to recipient
3765                     args.underlying.safeTransfer(
3766                         protocolFeeInfo_.recipient,
3767                         feeAmount
3768                     );
3769                 }
3770             }
3771 
3772             // add token output from minting to result
3773             tokenAmountOut = args.usePYT
3774                 ? tokenAmountIn
3775                 : args.xPYT.previewDeposit(tokenAmountIn);
3776 
3777             // use underlying to mint xPYT & NYT
3778             if (
3779                 args.underlying.allowance(address(this), address(args.gate)) <
3780                 tokenAmountIn
3781             ) {
3782                 args.underlying.safeApprove(
3783                     address(args.gate),
3784                     type(uint256).max
3785                 );
3786             }
3787             args.gate.enterWithUnderlying(
3788                 address(this), // nytRecipient
3789                 args.recipient, // pytRecipient
3790                 args.vault,
3791                 args.usePYT ? IxPYT(address(0)) : args.xPYT,
3792                 tokenAmountIn
3793             );
3794         }
3795 
3796         // swap NYT to xPYT
3797         uint256 swapOutput;
3798         {
3799             uint24 fee = abi.decode(args.extraArgs, (uint24));
3800             swapOutput = _swap(
3801                 args.nyt,
3802                 tokenAmountIn,
3803                 args.xPYT,
3804                 fee,
3805                 args.usePYT ? address(this) : args.recipient // set recipient to this when using PYT in order to unwrap xPYT
3806             );
3807         }
3808 
3809         // unwrap xPYT if necessary
3810         if (args.usePYT) {
3811             tokenAmountOut += args.xPYT.redeem(
3812                 swapOutput,
3813                 args.recipient,
3814                 address(this)
3815             );
3816         } else {
3817             tokenAmountOut += swapOutput;
3818         }
3819 
3820         // check slippage
3821         if (tokenAmountOut < args.minAmountOut) {
3822             revert Error_InsufficientOutput();
3823         }
3824     }
3825 
3826     /// @inheritdoc Swapper
3827     /// @dev extraArg = (uint24 fee, uint256 swapAmountIn)
3828     /// fee: The fee tier of the Uniswap V3 pool to use
3829     /// swapAmountIn: The amount of NYT to swap to xPYT
3830     function swapNytToUnderlying(SwapArgs calldata args)
3831         external
3832         payable
3833         virtual
3834         override
3835         nonReentrant
3836         returns (uint256 tokenAmountOut)
3837     {
3838         // check deadline
3839         if (block.timestamp > args.deadline) {
3840             revert Error_PastDeadline();
3841         }
3842 
3843         // transfer token input from sender
3844         uint256 tokenAmountIn = args.tokenAmountIn;
3845         if (!args.useSwapperBalance) {
3846             args.nyt.safeTransferFrom(msg.sender, address(this), tokenAmountIn);
3847         }
3848 
3849         // take protocol fee
3850         ProtocolFeeInfo memory protocolFeeInfo_ = protocolFeeInfo;
3851         if (protocolFeeInfo_.fee > 0) {
3852             uint256 feeAmount = (tokenAmountIn * protocolFeeInfo_.fee) / 10000;
3853             if (feeAmount > 0) {
3854                 // deduct fee from token input
3855                 tokenAmountIn -= feeAmount;
3856 
3857                 // transfer fee to recipient
3858                 args.nyt.safeTransfer(protocolFeeInfo_.recipient, feeAmount);
3859             }
3860         }
3861 
3862         // swap NYT to xPYT
3863         uint256 swapAmountOut;
3864         uint256 swapAmountIn;
3865         {
3866             uint24 fee;
3867             (fee, swapAmountIn) = abi.decode(args.extraArgs, (uint24, uint256));
3868             swapAmountOut = _swap(
3869                 args.nyt,
3870                 swapAmountIn,
3871                 args.xPYT,
3872                 fee,
3873                 address(this)
3874             );
3875 
3876             // convert swap output xPYT amount into equivalent PYT amount
3877             swapAmountOut = args.xPYT.convertToAssets(swapAmountOut);
3878         }
3879 
3880         // determine token output amount
3881         uint256 remainingAmountIn = args.useSwapperBalance
3882             ? args.nyt.balanceOf(address(this))
3883             : tokenAmountIn - swapAmountIn;
3884         if (remainingAmountIn < swapAmountOut) {
3885             // NYT to burn < PYT balance
3886             tokenAmountOut = remainingAmountIn;
3887         } else {
3888             // NYT balance >= PYT to burn
3889             tokenAmountOut = swapAmountOut;
3890         }
3891 
3892         // check slippage
3893         if (tokenAmountOut < args.minAmountOut) {
3894             revert Error_InsufficientOutput();
3895         }
3896 
3897         // burn xPYT & NYT into underlying
3898         if (
3899             args.xPYT.allowance(address(this), address(args.gate)) <
3900             args.xPYT.previewWithdraw(tokenAmountOut)
3901         ) {
3902             args.xPYT.safeApprove(address(args.gate), type(uint256).max);
3903         }
3904         args.gate.exitToUnderlying(
3905             args.recipient,
3906             args.vault,
3907             args.xPYT,
3908             tokenAmountOut
3909         );
3910 
3911         // handle leftover tokens
3912         if (remainingAmountIn < swapAmountOut) {
3913             // NYT to burn < PYT balance
3914             // give leftover xPYT to recipient
3915             if (args.usePYT) {
3916                 uint256 maxRedeemAmount = args.xPYT.maxRedeem(address(this));
3917                 if (maxRedeemAmount != 0) {
3918                     args.xPYT.redeem(
3919                         args.xPYT.maxRedeem(address(this)),
3920                         args.recipient,
3921                         address(this)
3922                     );
3923                 }
3924             } else {
3925                 args.xPYT.safeTransfer(
3926                     args.recipient,
3927                     args.xPYT.balanceOf(address(this))
3928                 );
3929             }
3930         } else {
3931             // NYT balance >= PYT to burn
3932             // give leftover NYT to recipient
3933             args.nyt.safeTransfer(
3934                 args.recipient,
3935                 args.nyt.balanceOf(address(this))
3936             );
3937         }
3938     }
3939 
3940     /// @inheritdoc Swapper
3941     /// @dev extraArg = (uint24 fee, uint256 swapAmountIn)
3942     /// fee: The fee tier of the Uniswap V3 pool to use
3943     /// swapAmountIn: The amount of xPYT to swap to NYT
3944     function swapXpytToUnderlying(SwapArgs calldata args)
3945         external
3946         payable
3947         virtual
3948         override
3949         nonReentrant
3950         returns (uint256 tokenAmountOut)
3951     {
3952         // check deadline
3953         if (block.timestamp > args.deadline) {
3954             revert Error_PastDeadline();
3955         }
3956 
3957         // transfer token input from sender
3958         uint256 tokenAmountIn = args.tokenAmountIn;
3959         if (!args.useSwapperBalance) {
3960             if (args.usePYT) {
3961                 // transfer PYT from sender to this
3962                 args.pyt.safeTransferFrom(
3963                     msg.sender,
3964                     address(this),
3965                     tokenAmountIn
3966                 );
3967 
3968                 // convert PYT input into xPYT and update tokenAmountIn
3969                 if (
3970                     args.pyt.allowance(address(this), address(args.xPYT)) <
3971                     tokenAmountIn
3972                 ) {
3973                     args.pyt.approve(address(args.xPYT), type(uint256).max);
3974                 }
3975                 tokenAmountIn = args.xPYT.deposit(tokenAmountIn, address(this));
3976             } else {
3977                 args.xPYT.safeTransferFrom(
3978                     msg.sender,
3979                     address(this),
3980                     tokenAmountIn
3981                 );
3982             }
3983         }
3984 
3985         // take protocol fee
3986         ProtocolFeeInfo memory protocolFeeInfo_ = protocolFeeInfo;
3987         if (protocolFeeInfo_.fee > 0) {
3988             uint256 feeAmount = (tokenAmountIn * protocolFeeInfo_.fee) / 10000;
3989             if (feeAmount > 0) {
3990                 // deduct fee from token input
3991                 tokenAmountIn -= feeAmount;
3992 
3993                 // transfer fee to recipient
3994                 args.xPYT.safeTransfer(protocolFeeInfo_.recipient, feeAmount);
3995             }
3996         }
3997 
3998         // swap xPYT to NYT
3999         uint256 swapAmountOut;
4000         uint256 swapAmountIn;
4001         {
4002             uint24 fee;
4003             (fee, swapAmountIn) = abi.decode(args.extraArgs, (uint24, uint256));
4004             swapAmountOut = _swap(
4005                 args.xPYT,
4006                 swapAmountIn,
4007                 args.nyt,
4008                 fee,
4009                 address(this)
4010             );
4011         }
4012 
4013         // determine token output amount
4014         uint256 remainingAmountIn = args.useSwapperBalance
4015             ? args.xPYT.balanceOf(address(this))
4016             : tokenAmountIn - swapAmountIn;
4017         // convert remainingAmountIn from xPYT amount to equivalent PYT amount
4018         remainingAmountIn = args.xPYT.previewRedeem(remainingAmountIn);
4019         if (remainingAmountIn < swapAmountOut) {
4020             // PYT to burn < NYT balance
4021             tokenAmountOut = remainingAmountIn;
4022         } else {
4023             // PYT balance >= NYT to burn
4024             tokenAmountOut = swapAmountOut;
4025         }
4026 
4027         // check slippage
4028         if (tokenAmountOut < args.minAmountOut) {
4029             revert Error_InsufficientOutput();
4030         }
4031 
4032         // burn xPYT & NYT into underlying
4033         if (
4034             args.xPYT.allowance(address(this), address(args.gate)) <
4035             args.xPYT.previewWithdraw(tokenAmountOut)
4036         ) {
4037             args.xPYT.safeApprove(address(args.gate), type(uint256).max);
4038         }
4039         args.gate.exitToUnderlying(
4040             args.recipient,
4041             args.vault,
4042             args.xPYT,
4043             tokenAmountOut
4044         );
4045 
4046         // handle leftover tokens
4047         if (remainingAmountIn < swapAmountOut) {
4048             // PYT to burn < NYT balance
4049             // give leftover NYT to recipient
4050             args.nyt.safeTransfer(
4051                 args.recipient,
4052                 args.nyt.balanceOf(address(this))
4053             );
4054         } else {
4055             // PYT balance >= NYT to burn
4056             // give leftover xPYT to recipient
4057             if (args.usePYT) {
4058                 uint256 maxRedeemAmount = args.xPYT.maxRedeem(address(this));
4059                 if (maxRedeemAmount != 0) {
4060                     args.xPYT.redeem(
4061                         args.xPYT.maxRedeem(address(this)),
4062                         args.recipient,
4063                         address(this)
4064                     );
4065                 }
4066             } else {
4067                 args.xPYT.safeTransfer(
4068                     args.recipient,
4069                     args.xPYT.balanceOf(address(this))
4070                 );
4071             }
4072         }
4073     }
4074 
4075     /// -----------------------------------------------------------------------
4076     /// Uniswap V3 support
4077     /// -----------------------------------------------------------------------
4078 
4079     /// @inheritdoc IUniswapV3SwapCallback
4080     function uniswapV3SwapCallback(
4081         int256 amount0Delta,
4082         int256 amount1Delta,
4083         bytes calldata data
4084     ) external {
4085         // determine amount to pay
4086         uint256 amountToPay;
4087         if (amount0Delta > 0) {
4088             amountToPay = uint256(amount0Delta);
4089         } else if (amount1Delta > 0) {
4090             amountToPay = uint256(amount1Delta);
4091         } else {
4092             revert Error_BothTokenDeltasAreZero();
4093         }
4094 
4095         // decode callback data
4096         SwapCallbackData memory callbackData = abi.decode(
4097             data,
4098             (SwapCallbackData)
4099         );
4100 
4101         // verify sender
4102         address pool = PoolAddress.computeAddress(
4103             uniswapV3Factory,
4104             PoolAddress.getPoolKey(
4105                 address(callbackData.tokenIn),
4106                 address(callbackData.tokenOut),
4107                 callbackData.fee
4108             )
4109         );
4110         if (msg.sender != address(pool)) {
4111             revert Error_NotUniswapV3Pool();
4112         }
4113 
4114         // pay tokens to the Uniswap V3 pool
4115         callbackData.tokenIn.safeTransfer(msg.sender, amountToPay);
4116     }
4117 
4118     /// -----------------------------------------------------------------------
4119     /// Internal utilities
4120     /// -----------------------------------------------------------------------
4121 
4122     /// @dev Use a Uniswap V3 pool to swap between two tokens
4123     /// @param tokenIn The input token
4124     /// @param tokenAmountIn The token input amount
4125     /// @param tokenOut The output token
4126     /// @param fee The fee tier of the pool to use
4127     /// @param recipient The address that will receive the token output
4128     function _swap(
4129         ERC20 tokenIn,
4130         uint256 tokenAmountIn,
4131         ERC20 tokenOut,
4132         uint24 fee,
4133         address recipient
4134     ) internal returns (uint256) {
4135         // get uniswap v3 pool
4136         IUniswapV3Pool uniPool = IUniswapV3Pool(
4137             PoolAddress.computeAddress(
4138                 uniswapV3Factory,
4139                 PoolAddress.getPoolKey(address(tokenIn), address(tokenOut), fee)
4140             )
4141         );
4142 
4143         // do swap
4144         bytes memory swapCallbackData = abi.encode(
4145             SwapCallbackData({tokenIn: tokenIn, tokenOut: tokenOut, fee: fee})
4146         );
4147         bool zeroForOne = address(tokenIn) < address(tokenOut);
4148         (int256 amount0, int256 amount1) = uniPool.swap(
4149             recipient,
4150             zeroForOne,
4151             tokenAmountIn.toInt256(),
4152             zeroForOne ? MIN_SQRT_RATIO_PLUS_ONE : MAX_SQRT_RATIO_MINUS_ONE,
4153             swapCallbackData
4154         );
4155 
4156         return uint256(-(zeroForOne ? amount1 : amount0));
4157     }
4158 }