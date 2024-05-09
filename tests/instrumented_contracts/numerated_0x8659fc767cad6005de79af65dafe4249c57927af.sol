1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 // File @rari-capital/solmate/src/tokens/ERC20.sol@v6.2.0
104 
105 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
106 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
107 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
108 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
109 abstract contract ERC20 {
110     /*///////////////////////////////////////////////////////////////
111                                   EVENTS
112     //////////////////////////////////////////////////////////////*/
113 
114     event Transfer(address indexed from, address indexed to, uint256 amount);
115 
116     event Approval(address indexed owner, address indexed spender, uint256 amount);
117 
118     /*///////////////////////////////////////////////////////////////
119                              METADATA STORAGE
120     //////////////////////////////////////////////////////////////*/
121 
122     string public name;
123 
124     string public symbol;
125 
126     uint8 public immutable decimals;
127 
128     /*///////////////////////////////////////////////////////////////
129                               ERC20 STORAGE
130     //////////////////////////////////////////////////////////////*/
131 
132     uint256 public totalSupply;
133 
134     mapping(address => uint256) public balanceOf;
135 
136     mapping(address => mapping(address => uint256)) public allowance;
137 
138     /*///////////////////////////////////////////////////////////////
139                              EIP-2612 STORAGE
140     //////////////////////////////////////////////////////////////*/
141 
142     uint256 internal immutable INITIAL_CHAIN_ID;
143 
144     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
145 
146     mapping(address => uint256) public nonces;
147 
148     /*///////////////////////////////////////////////////////////////
149                                CONSTRUCTOR
150     //////////////////////////////////////////////////////////////*/
151 
152     constructor(
153         string memory _name,
154         string memory _symbol,
155         uint8 _decimals
156     ) {
157         name = _name;
158         symbol = _symbol;
159         decimals = _decimals;
160 
161         INITIAL_CHAIN_ID = block.chainid;
162         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
163     }
164 
165     /*///////////////////////////////////////////////////////////////
166                               ERC20 LOGIC
167     //////////////////////////////////////////////////////////////*/
168 
169     function approve(address spender, uint256 amount) public virtual returns (bool) {
170         allowance[msg.sender][spender] = amount;
171 
172         emit Approval(msg.sender, spender, amount);
173 
174         return true;
175     }
176 
177     function transfer(address to, uint256 amount) public virtual returns (bool) {
178         balanceOf[msg.sender] -= amount;
179 
180         // Cannot overflow because the sum of all user
181         // balances can't exceed the max uint256 value.
182         unchecked {
183             balanceOf[to] += amount;
184         }
185 
186         emit Transfer(msg.sender, to, amount);
187 
188         return true;
189     }
190 
191     function transferFrom(
192         address from,
193         address to,
194         uint256 amount
195     ) public virtual returns (bool) {
196         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
197 
198         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
199 
200         balanceOf[from] -= amount;
201 
202         // Cannot overflow because the sum of all user
203         // balances can't exceed the max uint256 value.
204         unchecked {
205             balanceOf[to] += amount;
206         }
207 
208         emit Transfer(from, to, amount);
209 
210         return true;
211     }
212 
213     /*///////////////////////////////////////////////////////////////
214                               EIP-2612 LOGIC
215     //////////////////////////////////////////////////////////////*/
216 
217     function permit(
218         address owner,
219         address spender,
220         uint256 value,
221         uint256 deadline,
222         uint8 v,
223         bytes32 r,
224         bytes32 s
225     ) public virtual {
226         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
227 
228         // Unchecked because the only math done is incrementing
229         // the owner's nonce which cannot realistically overflow.
230         unchecked {
231             address recoveredAddress = ecrecover(
232                 keccak256(
233                     abi.encodePacked(
234                         "\x19\x01",
235                         DOMAIN_SEPARATOR(),
236                         keccak256(
237                             abi.encode(
238                                 keccak256(
239                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
240                                 ),
241                                 owner,
242                                 spender,
243                                 value,
244                                 nonces[owner]++,
245                                 deadline
246                             )
247                         )
248                     )
249                 ),
250                 v,
251                 r,
252                 s
253             );
254 
255             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
256 
257             allowance[recoveredAddress][spender] = value;
258         }
259 
260         emit Approval(owner, spender, value);
261     }
262 
263     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
264         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
265     }
266 
267     function computeDomainSeparator() internal view virtual returns (bytes32) {
268         return
269             keccak256(
270                 abi.encode(
271                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
272                     keccak256(bytes(name)),
273                     keccak256("1"),
274                     block.chainid,
275                     address(this)
276                 )
277             );
278     }
279 
280     /*///////////////////////////////////////////////////////////////
281                        INTERNAL MINT/BURN LOGIC
282     //////////////////////////////////////////////////////////////*/
283 
284     function _mint(address to, uint256 amount) internal virtual {
285         totalSupply += amount;
286 
287         // Cannot overflow because the sum of all user
288         // balances can't exceed the max uint256 value.
289         unchecked {
290             balanceOf[to] += amount;
291         }
292 
293         emit Transfer(address(0), to, amount);
294     }
295 
296     function _burn(address from, uint256 amount) internal virtual {
297         balanceOf[from] -= amount;
298 
299         // Cannot underflow because a user's balance
300         // will never be larger than the total supply.
301         unchecked {
302             totalSupply -= amount;
303         }
304 
305         emit Transfer(from, address(0), amount);
306     }
307 }
308 
309 
310 // File @rari-capital/solmate/src/utils/SafeTransferLib.sol@v6.2.0
311 
312 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
313 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
314 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
315 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
316 library SafeTransferLib {
317     event Debug(bool one, bool two, uint256 retsize);
318 
319     /*///////////////////////////////////////////////////////////////
320                             ETH OPERATIONS
321     //////////////////////////////////////////////////////////////*/
322 
323     function safeTransferETH(address to, uint256 amount) internal {
324         bool success;
325 
326         assembly {
327             // Transfer the ETH and store if it succeeded or not.
328             success := call(gas(), to, amount, 0, 0, 0, 0)
329         }
330 
331         require(success, "ETH_TRANSFER_FAILED");
332     }
333 
334     /*///////////////////////////////////////////////////////////////
335                            ERC20 OPERATIONS
336     //////////////////////////////////////////////////////////////*/
337 
338     function safeTransferFrom(
339         ERC20 token,
340         address from,
341         address to,
342         uint256 amount
343     ) internal {
344         bool success;
345 
346         assembly {
347             // Get a pointer to some free memory.
348             let freeMemoryPointer := mload(0x40)
349 
350             // Write the abi-encoded calldata into memory, beginning with the function selector.
351             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
352             mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
353             mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
354             mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
355 
356             success := and(
357                 // Set success to whether the call reverted, if not we check it either
358                 // returned exactly 1 (can't just be non-zero data), or had no return data.
359                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
360                 // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
361                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
362                 // Counterintuitively, this call must be positioned second to the or() call in the
363                 // surrounding and() call or else returndatasize() will be zero during the computation.
364                 call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
365             )
366         }
367 
368         require(success, "TRANSFER_FROM_FAILED");
369     }
370 
371     function safeTransfer(
372         ERC20 token,
373         address to,
374         uint256 amount
375     ) internal {
376         bool success;
377 
378         assembly {
379             // Get a pointer to some free memory.
380             let freeMemoryPointer := mload(0x40)
381 
382             // Write the abi-encoded calldata into memory, beginning with the function selector.
383             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
384             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
385             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
386 
387             success := and(
388                 // Set success to whether the call reverted, if not we check it either
389                 // returned exactly 1 (can't just be non-zero data), or had no return data.
390                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
391                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
392                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
393                 // Counterintuitively, this call must be positioned second to the or() call in the
394                 // surrounding and() call or else returndatasize() will be zero during the computation.
395                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
396             )
397         }
398 
399         require(success, "TRANSFER_FAILED");
400     }
401 
402     function safeApprove(
403         ERC20 token,
404         address to,
405         uint256 amount
406     ) internal {
407         bool success;
408 
409         assembly {
410             // Get a pointer to some free memory.
411             let freeMemoryPointer := mload(0x40)
412 
413             // Write the abi-encoded calldata into memory, beginning with the function selector.
414             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
415             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
416             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
417 
418             success := and(
419                 // Set success to whether the call reverted, if not we check it either
420                 // returned exactly 1 (can't just be non-zero data), or had no return data.
421                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
422                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
423                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
424                 // Counterintuitively, this call must be positioned second to the or() call in the
425                 // surrounding and() call or else returndatasize() will be zero during the computation.
426                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
427             )
428         }
429 
430         require(success, "APPROVE_FAILED");
431     }
432 }
433 
434 
435 // File @rari-capital/solmate/src/utils/FixedPointMathLib.sol@v6.2.0
436 
437 /// @notice Arithmetic library with operations for fixed-point numbers.
438 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/FixedPointMathLib.sol)
439 /// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
440 library FixedPointMathLib {
441     /*///////////////////////////////////////////////////////////////
442                     SIMPLIFIED FIXED POINT OPERATIONS
443     //////////////////////////////////////////////////////////////*/
444 
445     uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.
446 
447     function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
448         return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
449     }
450 
451     function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
452         return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
453     }
454 
455     function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
456         return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
457     }
458 
459     function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
460         return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
461     }
462 
463     /*///////////////////////////////////////////////////////////////
464                     LOW LEVEL FIXED POINT OPERATIONS
465     //////////////////////////////////////////////////////////////*/
466 
467     function mulDivDown(
468         uint256 x,
469         uint256 y,
470         uint256 denominator
471     ) internal pure returns (uint256 z) {
472         assembly {
473             // Store x * y in z for now.
474             z := mul(x, y)
475 
476             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
477             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
478                 revert(0, 0)
479             }
480 
481             // Divide z by the denominator.
482             z := div(z, denominator)
483         }
484     }
485 
486     function mulDivUp(
487         uint256 x,
488         uint256 y,
489         uint256 denominator
490     ) internal pure returns (uint256 z) {
491         assembly {
492             // Store x * y in z for now.
493             z := mul(x, y)
494 
495             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
496             if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
497                 revert(0, 0)
498             }
499 
500             // First, divide z - 1 by the denominator and add 1.
501             // We allow z - 1 to underflow if z is 0, because we multiply the
502             // end result by 0 if z is zero, ensuring we return 0 if z is zero.
503             z := mul(iszero(iszero(z)), add(div(sub(z, 1), denominator), 1))
504         }
505     }
506 
507     function rpow(
508         uint256 x,
509         uint256 n,
510         uint256 scalar
511     ) internal pure returns (uint256 z) {
512         assembly {
513             switch x
514             case 0 {
515                 switch n
516                 case 0 {
517                     // 0 ** 0 = 1
518                     z := scalar
519                 }
520                 default {
521                     // 0 ** n = 0
522                     z := 0
523                 }
524             }
525             default {
526                 switch mod(n, 2)
527                 case 0 {
528                     // If n is even, store scalar in z for now.
529                     z := scalar
530                 }
531                 default {
532                     // If n is odd, store x in z for now.
533                     z := x
534                 }
535 
536                 // Shifting right by 1 is like dividing by 2.
537                 let half := shr(1, scalar)
538 
539                 for {
540                     // Shift n right by 1 before looping to halve it.
541                     n := shr(1, n)
542                 } n {
543                     // Shift n right by 1 each iteration to halve it.
544                     n := shr(1, n)
545                 } {
546                     // Revert immediately if x ** 2 would overflow.
547                     // Equivalent to iszero(eq(div(xx, x), x)) here.
548                     if shr(128, x) {
549                         revert(0, 0)
550                     }
551 
552                     // Store x squared.
553                     let xx := mul(x, x)
554 
555                     // Round to the nearest number.
556                     let xxRound := add(xx, half)
557 
558                     // Revert if xx + half overflowed.
559                     if lt(xxRound, xx) {
560                         revert(0, 0)
561                     }
562 
563                     // Set x to scaled xxRound.
564                     x := div(xxRound, scalar)
565 
566                     // If n is even:
567                     if mod(n, 2) {
568                         // Compute z * x.
569                         let zx := mul(z, x)
570 
571                         // If z * x overflowed:
572                         if iszero(eq(div(zx, x), z)) {
573                             // Revert if x is non-zero.
574                             if iszero(iszero(x)) {
575                                 revert(0, 0)
576                             }
577                         }
578 
579                         // Round to the nearest number.
580                         let zxRound := add(zx, half)
581 
582                         // Revert if zx + half overflowed.
583                         if lt(zxRound, zx) {
584                             revert(0, 0)
585                         }
586 
587                         // Return properly scaled zxRound.
588                         z := div(zxRound, scalar)
589                     }
590                 }
591             }
592         }
593     }
594 
595     /*///////////////////////////////////////////////////////////////
596                         GENERAL NUMBER UTILITIES
597     //////////////////////////////////////////////////////////////*/
598 
599     function sqrt(uint256 x) internal pure returns (uint256 z) {
600         assembly {
601             // Start off with z at 1.
602             z := 1
603 
604             // Used below to help find a nearby power of 2.
605             let y := x
606 
607             // Find the lowest power of 2 that is at least sqrt(x).
608             if iszero(lt(y, 0x100000000000000000000000000000000)) {
609                 y := shr(128, y) // Like dividing by 2 ** 128.
610                 z := shl(64, z) // Like multiplying by 2 ** 64.
611             }
612             if iszero(lt(y, 0x10000000000000000)) {
613                 y := shr(64, y) // Like dividing by 2 ** 64.
614                 z := shl(32, z) // Like multiplying by 2 ** 32.
615             }
616             if iszero(lt(y, 0x100000000)) {
617                 y := shr(32, y) // Like dividing by 2 ** 32.
618                 z := shl(16, z) // Like multiplying by 2 ** 16.
619             }
620             if iszero(lt(y, 0x10000)) {
621                 y := shr(16, y) // Like dividing by 2 ** 16.
622                 z := shl(8, z) // Like multiplying by 2 ** 8.
623             }
624             if iszero(lt(y, 0x100)) {
625                 y := shr(8, y) // Like dividing by 2 ** 8.
626                 z := shl(4, z) // Like multiplying by 2 ** 4.
627             }
628             if iszero(lt(y, 0x10)) {
629                 y := shr(4, y) // Like dividing by 2 ** 4.
630                 z := shl(2, z) // Like multiplying by 2 ** 2.
631             }
632             if iszero(lt(y, 0x8)) {
633                 // Equivalent to 2 ** z.
634                 z := shl(1, z)
635             }
636 
637             // Shifting right by 1 is like dividing by 2.
638             z := shr(1, add(z, div(x, z)))
639             z := shr(1, add(z, div(x, z)))
640             z := shr(1, add(z, div(x, z)))
641             z := shr(1, add(z, div(x, z)))
642             z := shr(1, add(z, div(x, z)))
643             z := shr(1, add(z, div(x, z)))
644             z := shr(1, add(z, div(x, z)))
645 
646             // Compute a rounded down version of z.
647             let zRoundDown := div(x, z)
648 
649             // If zRoundDown is smaller, use it.
650             if lt(zRoundDown, z) {
651                 z := zRoundDown
652             }
653         }
654     }
655 }
656 
657 
658 // File @rari-capital/solmate/src/mixins/ERC4626.sol@v6.2.0
659 
660 
661 
662 /// @notice Minimal ERC4626 tokenized Vault implementation.
663 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/mixins/ERC4626.sol)
664 abstract contract ERC4626 is ERC20 {
665     using SafeTransferLib for ERC20;
666     using FixedPointMathLib for uint256;
667 
668     /*///////////////////////////////////////////////////////////////
669                                  EVENTS
670     //////////////////////////////////////////////////////////////*/
671 
672     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
673 
674     event Withdraw(
675         address indexed caller,
676         address indexed receiver,
677         address indexed owner,
678         uint256 assets,
679         uint256 shares
680     );
681 
682     /*///////////////////////////////////////////////////////////////
683                                IMMUTABLES
684     //////////////////////////////////////////////////////////////*/
685 
686     ERC20 public immutable asset;
687 
688     constructor(
689         ERC20 _asset,
690         string memory _name,
691         string memory _symbol
692     ) ERC20(_name, _symbol, _asset.decimals()) {
693         asset = _asset;
694     }
695 
696     /*///////////////////////////////////////////////////////////////
697                         DEPOSIT/WITHDRAWAL LOGIC
698     //////////////////////////////////////////////////////////////*/
699 
700     function deposit(uint256 assets, address receiver) public virtual returns (uint256 shares) {
701         // Check for rounding error since we round down in previewDeposit.
702         require((shares = previewDeposit(assets)) != 0, "ZERO_SHARES");
703 
704         // Need to transfer before minting or ERC777s could reenter.
705         asset.safeTransferFrom(msg.sender, address(this), assets);
706 
707         _mint(receiver, shares);
708 
709         emit Deposit(msg.sender, receiver, assets, shares);
710 
711         afterDeposit(assets, shares);
712     }
713 
714     function mint(uint256 shares, address receiver) public virtual returns (uint256 assets) {
715         assets = previewMint(shares); // No need to check for rounding error, previewMint rounds up.
716 
717         // Need to transfer before minting or ERC777s could reenter.
718         asset.safeTransferFrom(msg.sender, address(this), assets);
719 
720         _mint(receiver, shares);
721 
722         emit Deposit(msg.sender, receiver, assets, shares);
723 
724         afterDeposit(assets, shares);
725     }
726 
727     function withdraw(
728         uint256 assets,
729         address receiver,
730         address owner
731     ) public virtual returns (uint256 shares) {
732         shares = previewWithdraw(assets); // No need to check for rounding error, previewWithdraw rounds up.
733 
734         if (msg.sender != owner) {
735             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
736 
737             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
738         }
739 
740         beforeWithdraw(assets, shares);
741 
742         _burn(owner, shares);
743 
744         emit Withdraw(msg.sender, receiver, owner, assets, shares);
745 
746         asset.safeTransfer(receiver, assets);
747     }
748 
749     function redeem(
750         uint256 shares,
751         address receiver,
752         address owner
753     ) public virtual returns (uint256 assets) {
754         if (msg.sender != owner) {
755             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
756 
757             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
758         }
759 
760         // Check for rounding error since we round down in previewRedeem.
761         require((assets = previewRedeem(shares)) != 0, "ZERO_ASSETS");
762 
763         beforeWithdraw(assets, shares);
764 
765         _burn(owner, shares);
766 
767         emit Withdraw(msg.sender, receiver, owner, assets, shares);
768 
769         asset.safeTransfer(receiver, assets);
770     }
771 
772     /*///////////////////////////////////////////////////////////////
773                            ACCOUNTING LOGIC
774     //////////////////////////////////////////////////////////////*/
775 
776     function totalAssets() public view virtual returns (uint256);
777 
778     function convertToShares(uint256 assets) public view virtual returns (uint256) {
779         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
780 
781         return supply == 0 ? assets : assets.mulDivDown(supply, totalAssets());
782     }
783 
784     function convertToAssets(uint256 shares) public view virtual returns (uint256) {
785         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
786 
787         return supply == 0 ? shares : shares.mulDivDown(totalAssets(), supply);
788     }
789 
790     function previewDeposit(uint256 assets) public view virtual returns (uint256) {
791         return convertToShares(assets);
792     }
793 
794     function previewMint(uint256 shares) public view virtual returns (uint256) {
795         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
796 
797         return supply == 0 ? shares : shares.mulDivUp(totalAssets(), supply);
798     }
799 
800     function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
801         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
802 
803         return supply == 0 ? assets : assets.mulDivUp(supply, totalAssets());
804     }
805 
806     function previewRedeem(uint256 shares) public view virtual returns (uint256) {
807         return convertToAssets(shares);
808     }
809 
810     /*///////////////////////////////////////////////////////////////
811                      DEPOSIT/WITHDRAWAL LIMIT LOGIC
812     //////////////////////////////////////////////////////////////*/
813 
814     function maxDeposit(address) public view virtual returns (uint256) {
815         return type(uint256).max;
816     }
817 
818     function maxMint(address) public view virtual returns (uint256) {
819         return type(uint256).max;
820     }
821 
822     function maxWithdraw(address owner) public view virtual returns (uint256) {
823         return convertToAssets(balanceOf[owner]);
824     }
825 
826     function maxRedeem(address owner) public view virtual returns (uint256) {
827         return balanceOf[owner];
828     }
829 
830     /*///////////////////////////////////////////////////////////////
831                          INTERNAL HOOKS LOGIC
832     //////////////////////////////////////////////////////////////*/
833 
834     function beforeWithdraw(uint256 assets, uint256 shares) internal virtual {}
835 
836     function afterDeposit(uint256 assets, uint256 shares) internal virtual {}
837 }
838 
839 
840 // File contracts/vault/UnionPirexStaking.sol
841 
842 
843 
844 // https://docs.synthetix.io/contracts/source/contracts/StakingRewards/
845 // https://github.com/Synthetixio/synthetix/blob/v2.66.0/contracts/StakingRewards.sol
846 /**
847   Modifications
848     - Pin pragma to 0.8.12
849     - Remove IStakingRewards, RewardsDistributionRecipient, and Pausable
850     - Add and inherit from Ownable
851     - Add `RewardsDistributionRecipient` logic to contract
852     - Add `vault` state variable and `onlyVault` modifier
853     - Add `onlyVault` modifier to `stake` method
854     - Change `rewardsDuration` to 14 days
855     - Update contract to support only the vault as a user
856     - Remove SafeMath since pragma 0.8.0 has those checks built-in
857     - Replace OpenZeppelin ERC20, ReentrancyGuard, and SafeERC20 with Solmate v6 (audited)
858     - Consolidate `rewardsToken` and `stakingToken` since they're the same
859     - Remove `onlyVault` modifier from getReward
860     - Remove ReentrancyGuard as it is no longer needed
861     - Add `totalSupplyWithRewards` method to save gas as _totalSupply + rewards are accessed by vault
862     - Updated `notifyRewardsAmount`
863         - Remove the method parameter and compute the reward amount inside the function
864         - Remove the conditional logic since we will always distribute the rewards balance
865         - Remove overflow check since the caller cannot pass in the reward amount
866 */
867 contract UnionPirexStaking is Ownable {
868     using SafeTransferLib for ERC20;
869 
870     /* ========== STATE VARIABLES ========== */
871 
872     address public immutable vault;
873     ERC20 public immutable token;
874 
875     uint256 public constant rewardsDuration = 14 days;
876 
877     address public distributor;
878     uint256 public periodFinish;
879     uint256 public rewardRate;
880     uint256 public lastUpdateTime;
881     uint256 public rewardPerTokenStored;
882     uint256 public userRewardPerTokenPaid;
883     uint256 public rewards;
884 
885     uint256 internal _totalSupply;
886 
887     /* ========== CONSTRUCTOR ========== */
888 
889     constructor(
890         address _token,
891         address _distributor,
892         address _vault
893     ) {
894         token = ERC20(_token);
895         distributor = _distributor;
896         vault = _vault;
897     }
898 
899     /* ========== VIEWS ========== */
900 
901     function totalSupply() external view returns (uint256) {
902         return _totalSupply;
903     }
904 
905     function totalSupplyWithRewards() external view returns (uint256, uint256) {
906         uint256 t = _totalSupply;
907 
908         return (
909             t,
910             ((t * (rewardPerToken() - userRewardPerTokenPaid)) / 1e18) + rewards
911         );
912     }
913 
914     function lastTimeRewardApplicable() public view returns (uint256) {
915         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
916     }
917 
918     function rewardPerToken() public view returns (uint256) {
919         if (_totalSupply == 0) {
920             return rewardPerTokenStored;
921         }
922 
923         return
924             rewardPerTokenStored +
925             ((((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate) *
926                 1e18) / _totalSupply);
927     }
928 
929     function earned() public view returns (uint256) {
930         return
931             ((_totalSupply * (rewardPerToken() - userRewardPerTokenPaid)) /
932                 1e18) + rewards;
933     }
934 
935     function getRewardForDuration() external view returns (uint256) {
936         return rewardRate * rewardsDuration;
937     }
938 
939     /* ========== MUTATIVE FUNCTIONS ========== */
940 
941     function stake(uint256 amount) external onlyVault updateReward(vault) {
942         require(amount > 0, "Cannot stake 0");
943         _totalSupply += amount;
944         token.safeTransferFrom(vault, address(this), amount);
945         emit Staked(amount);
946     }
947 
948     function withdraw(uint256 amount) external onlyVault updateReward(vault) {
949         require(amount > 0, "Cannot withdraw 0");
950         _totalSupply -= amount;
951         token.safeTransfer(vault, amount);
952         emit Withdrawn(amount);
953     }
954 
955     function getReward() external updateReward(vault) {
956         uint256 reward = rewards;
957 
958         if (reward > 0) {
959             rewards = 0;
960             token.safeTransfer(vault, reward);
961             emit RewardPaid(reward);
962         }
963     }
964 
965     /* ========== RESTRICTED FUNCTIONS ========== */
966 
967     function notifyRewardAmount()
968         external
969         onlyDistributor
970         updateReward(address(0))
971     {
972         // Rewards transferred directly to this contract are not added to _totalSupply
973         // To get the rewards w/o relying on a potentially incorrect passed in arg,
974         // we can use the difference between the token balance and _totalSupply.
975         // Additionally, to avoid re-distributing rewards, deduct the output of `earned`
976         uint256 rewardBalance = token.balanceOf(address(this)) -
977             _totalSupply -
978             earned();
979 
980         rewardRate = rewardBalance / rewardsDuration;
981         require(rewardRate != 0, "No rewards");
982 
983         lastUpdateTime = block.timestamp;
984         periodFinish = block.timestamp + rewardsDuration;
985 
986         emit RewardAdded(rewardBalance);
987     }
988 
989     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
990     function recoverERC20(address tokenAddress, uint256 tokenAmount)
991         external
992         onlyOwner
993     {
994         require(
995             tokenAddress != address(token),
996             "Cannot withdraw the staking token"
997         );
998         ERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
999         emit Recovered(tokenAddress, tokenAmount);
1000     }
1001 
1002     function setDistributor(address _distributor) external onlyOwner {
1003         require(_distributor != address(0));
1004         distributor = _distributor;
1005     }
1006 
1007     /* ========== MODIFIERS ========== */
1008 
1009     modifier updateReward(address account) {
1010         rewardPerTokenStored = rewardPerToken();
1011         lastUpdateTime = lastTimeRewardApplicable();
1012         if (account != address(0)) {
1013             rewards = earned();
1014             userRewardPerTokenPaid = rewardPerTokenStored;
1015         }
1016         _;
1017     }
1018 
1019     /* ========== EVENTS ========== */
1020 
1021     event RewardAdded(uint256 reward);
1022     event Staked(uint256 amount);
1023     event Withdrawn(uint256 amount);
1024     event RewardPaid(uint256 reward);
1025     event Recovered(address token, uint256 amount);
1026 
1027     modifier onlyDistributor() {
1028         require((msg.sender == distributor), "Distributor only");
1029         _;
1030     }
1031 
1032     modifier onlyVault() {
1033         require((msg.sender == vault), "Vault only");
1034         _;
1035     }
1036 }
1037 
1038 
1039 // File contracts/vault/UnionPirexVault.sol
1040 
1041 
1042 // SPDX-License-Identifier: MIT
1043 pragma solidity 0.8.12;
1044 
1045 
1046 
1047 contract UnionPirexVault is Ownable, ERC4626 {
1048     using SafeTransferLib for ERC20;
1049     using FixedPointMathLib for uint256;
1050 
1051     UnionPirexStaking public strategy;
1052 
1053     uint256 public constant MAX_WITHDRAWAL_PENALTY = 500;
1054     uint256 public constant MAX_PLATFORM_FEE = 2000;
1055     uint256 public constant FEE_DENOMINATOR = 10000;
1056 
1057     uint256 public withdrawalPenalty = 300;
1058     uint256 public platformFee = 1000;
1059     address public platform;
1060 
1061     event Harvest(address indexed caller, uint256 value);
1062     event WithdrawalPenaltyUpdated(uint256 penalty);
1063     event PlatformFeeUpdated(uint256 fee);
1064     event PlatformUpdated(address indexed _platform);
1065     event StrategySet(address indexed _strategy);
1066 
1067     error ZeroAddress();
1068     error ExceedsMax();
1069     error AlreadySet();
1070 
1071     constructor(address pxCvx) ERC4626(ERC20(pxCvx), "Union Pirex", "uCVX") {}
1072 
1073     /**
1074         @notice Set the withdrawal penalty
1075         @param  penalty  uint256  Withdrawal penalty
1076      */
1077     function setWithdrawalPenalty(uint256 penalty) external onlyOwner {
1078         if (penalty > MAX_WITHDRAWAL_PENALTY) revert ExceedsMax();
1079 
1080         withdrawalPenalty = penalty;
1081 
1082         emit WithdrawalPenaltyUpdated(penalty);
1083     }
1084 
1085     /**
1086         @notice Set the platform fee
1087         @param  fee  uint256  Platform fee
1088      */
1089     function setPlatformFee(uint256 fee) external onlyOwner {
1090         if (fee > MAX_PLATFORM_FEE) revert ExceedsMax();
1091 
1092         platformFee = fee;
1093 
1094         emit PlatformFeeUpdated(fee);
1095     }
1096 
1097     /**
1098         @notice Set the platform
1099         @param  _platform  address  Platform
1100      */
1101     function setPlatform(address _platform) external onlyOwner {
1102         if (_platform == address(0)) revert ZeroAddress();
1103 
1104         platform = _platform;
1105 
1106         emit PlatformUpdated(_platform);
1107     }
1108 
1109     /**
1110         @notice Set the strategy
1111         @param  _strategy  address  Strategy
1112      */
1113     function setStrategy(address _strategy) external onlyOwner {
1114         if (_strategy == address(0)) revert ZeroAddress();
1115         if (address(strategy) != address(0)) revert AlreadySet();
1116 
1117         // Set new strategy contract and approve max allowance
1118         strategy = UnionPirexStaking(_strategy);
1119 
1120         asset.safeApprove(_strategy, type(uint256).max);
1121 
1122         emit StrategySet(_strategy);
1123     }
1124 
1125     /**
1126         @notice Get the pxCVX custodied by the UnionPirex contracts
1127         @return uint256  Assets
1128      */
1129     function totalAssets() public view override returns (uint256) {
1130         // Vault assets + rewards should always be stored in strategy until withdrawal-time
1131         (uint256 _totalSupply, uint256 rewards) = strategy
1132             .totalSupplyWithRewards();
1133 
1134         // Deduct the exact reward amount staked (after fees are deducted when calling `harvest`)
1135         return
1136             _totalSupply +
1137             (
1138                 rewards == 0
1139                     ? 0
1140                     : (rewards - ((rewards * platformFee) / FEE_DENOMINATOR))
1141             );
1142     }
1143 
1144     /**
1145         @notice Withdraw assets from the staking contract to prepare for transfer to user
1146         @param  assets  uint256  Assets
1147      */
1148     function beforeWithdraw(uint256 assets, uint256) internal override {
1149         // Harvest rewards in the event where there is not enough staked assets to cover the withdrawal
1150         if (assets > strategy.totalSupply()) harvest();
1151 
1152         strategy.withdraw(assets);
1153     }
1154 
1155     /**
1156         @notice Stake assets so that rewards can be properly distributed
1157         @param  assets  uint256  Assets
1158      */
1159     function afterDeposit(uint256 assets, uint256) internal override {
1160         strategy.stake(assets);
1161     }
1162 
1163     /**
1164         @notice Preview the amount of assets a user would receive from redeeming shares
1165         @param  shares  uint256  Shares
1166         @return uint256  Assets
1167      */
1168     function previewRedeem(uint256 shares)
1169         public
1170         view
1171         override
1172         returns (uint256)
1173     {
1174         // Calculate assets based on a user's % ownership of vault shares
1175         uint256 assets = convertToAssets(shares);
1176 
1177         uint256 _totalSupply = totalSupply;
1178 
1179         // Calculate a penalty - zero if user is the last to withdraw
1180         uint256 penalty = (_totalSupply == 0 || _totalSupply - shares == 0)
1181             ? 0
1182             : assets.mulDivDown(withdrawalPenalty, FEE_DENOMINATOR);
1183 
1184         // Redeemable amount is the post-penalty amount
1185         return assets - penalty;
1186     }
1187 
1188     /**
1189         @notice Preview the amount of shares a user would need to redeem the specified asset amount
1190         @notice This modified version takes into consideration the withdrawal fee
1191         @param  assets  uint256  Assets
1192         @return uint256  Shares
1193      */
1194     function previewWithdraw(uint256 assets)
1195         public
1196         view
1197         override
1198         returns (uint256)
1199     {
1200         // Calculate shares based on the specified assets' proportion of the pool
1201         uint256 shares = convertToShares(assets);
1202 
1203         // Save 1 SLOAD
1204         uint256 _totalSupply = totalSupply;
1205 
1206         // Factor in additional shares to fulfill withdrawal if user is not the last to withdraw
1207         return
1208             (_totalSupply == 0 || _totalSupply - shares == 0)
1209                 ? shares
1210                 : (shares * FEE_DENOMINATOR) /
1211                     (FEE_DENOMINATOR - withdrawalPenalty);
1212     }
1213 
1214     /**
1215         @notice Harvest rewards
1216      */
1217     function harvest() public {
1218         // Claim rewards
1219         strategy.getReward();
1220 
1221         // Since we don't normally store pxCVX within the vault, a non-zero balance equals rewards
1222         uint256 rewards = asset.balanceOf(address(this));
1223 
1224         emit Harvest(msg.sender, rewards);
1225 
1226         if (rewards != 0) {
1227             // Fee for platform
1228             uint256 feeAmount = (rewards * platformFee) / FEE_DENOMINATOR;
1229 
1230             // Deduct fee from reward balance
1231             rewards -= feeAmount;
1232 
1233             // Claimed rewards should be in pxCVX
1234             asset.safeTransfer(platform, feeAmount);
1235 
1236             // Stake rewards sans fee
1237             strategy.stake(rewards);
1238         }
1239     }
1240 }