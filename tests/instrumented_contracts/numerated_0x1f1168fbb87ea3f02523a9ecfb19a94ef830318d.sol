1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 error NotOwner();
5 
6 abstract contract LilOwnable {
7     address internal _owner;
8 
9     event OwnershipTransferred(
10         address indexed previousOwner,
11         address indexed newOwner
12     );
13 
14     constructor() {
15         _owner = msg.sender;
16     }
17 
18     function owner() external view returns (address) {
19         return _owner;
20     }
21 
22     function transferOwnership(address _newOwner) external {
23         if (msg.sender != _owner) revert NotOwner();
24 
25         _owner = _newOwner;
26     }
27 
28     function renounceOwnership() public {
29         if (msg.sender != _owner) revert NotOwner();
30 
31         _owner = address(0);
32     }
33 
34     function supportsInterface(bytes4 interfaceId)
35         public
36         pure
37         virtual
38         returns (bool)
39     {
40         return interfaceId == 0x7f5828d0; // ERC165 Interface ID for ERC173
41     }
42 }
43 
44 
45 library Strings {
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
48      */
49     function toString(uint256 value) internal pure returns (string memory) {
50         // Inspired by OraclizeAPI's implementation - MIT licence
51         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
52 
53         if (value == 0) {
54             return "0";
55         }
56         uint256 temp = value;
57         uint256 digits;
58         while (temp != 0) {
59             digits++;
60             temp /= 10;
61         }
62         bytes memory buffer = new bytes(digits);
63         while (value != 0) {
64             digits -= 1;
65             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
66             value /= 10;
67         }
68         return string(buffer);
69     }
70 }
71 
72 
73 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
74 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
75 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
76 abstract contract ERC721 {
77     /*///////////////////////////////////////////////////////////////
78                                  EVENTS
79     //////////////////////////////////////////////////////////////*/
80 
81     event Transfer(address indexed from, address indexed to, uint256 indexed id);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
84 
85     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
86 
87     /*///////////////////////////////////////////////////////////////
88                           METADATA STORAGE/LOGIC
89     //////////////////////////////////////////////////////////////*/
90 
91     string public name;
92 
93     string public symbol;
94 
95     function tokenURI(uint256 id) public view virtual returns (string memory);
96 
97     /*///////////////////////////////////////////////////////////////
98                             ERC721 STORAGE                        
99     //////////////////////////////////////////////////////////////*/
100 
101     mapping(address => uint256) public balanceOf;
102 
103     mapping(uint256 => address) public ownerOf;
104 
105     mapping(uint256 => address) public getApproved;
106 
107     mapping(address => mapping(address => bool)) public isApprovedForAll;
108 
109     /*///////////////////////////////////////////////////////////////
110                               CONSTRUCTOR
111     //////////////////////////////////////////////////////////////*/
112 
113     constructor(string memory _name, string memory _symbol) {
114         name = _name;
115         symbol = _symbol;
116     }
117 
118     /*///////////////////////////////////////////////////////////////
119                               ERC721 LOGIC
120     //////////////////////////////////////////////////////////////*/
121 
122     function approve(address spender, uint256 id) public virtual {
123         address owner = ownerOf[id];
124 
125         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
126 
127         getApproved[id] = spender;
128 
129         emit Approval(owner, spender, id);
130     }
131 
132     function setApprovalForAll(address operator, bool approved) public virtual {
133         isApprovedForAll[msg.sender][operator] = approved;
134 
135         emit ApprovalForAll(msg.sender, operator, approved);
136     }
137 
138     function transferFrom(
139         address from,
140         address to,
141         uint256 id
142     ) public virtual {
143         require(from == ownerOf[id], "WRONG_FROM");
144 
145         require(to != address(0), "INVALID_RECIPIENT");
146 
147         require(
148             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
149             "NOT_AUTHORIZED"
150         );
151 
152         // Underflow of the sender's balance is impossible because we check for
153         // ownership above and the recipient's balance can't realistically overflow.
154         unchecked {
155             balanceOf[from]--;
156 
157             balanceOf[to]++;
158         }
159 
160         ownerOf[id] = to;
161 
162         delete getApproved[id];
163 
164         emit Transfer(from, to, id);
165     }
166 
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 id
171     ) public virtual {
172         transferFrom(from, to, id);
173 
174         require(
175             to.code.length == 0 ||
176                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
177                 ERC721TokenReceiver.onERC721Received.selector,
178             "UNSAFE_RECIPIENT"
179         );
180     }
181 
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 id,
186         bytes memory data
187     ) public virtual {
188         transferFrom(from, to, id);
189 
190         require(
191             to.code.length == 0 ||
192                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
193                 ERC721TokenReceiver.onERC721Received.selector,
194             "UNSAFE_RECIPIENT"
195         );
196     }
197 
198     /*///////////////////////////////////////////////////////////////
199                               ERC165 LOGIC
200     //////////////////////////////////////////////////////////////*/
201 
202     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
203         return
204             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
205             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
206             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
207     }
208 
209     /*///////////////////////////////////////////////////////////////
210                        INTERNAL MINT/BURN LOGIC
211     //////////////////////////////////////////////////////////////*/
212 
213     function _mint(address to, uint256 id) internal virtual {
214         require(to != address(0), "INVALID_RECIPIENT");
215 
216         require(ownerOf[id] == address(0), "ALREADY_MINTED");
217 
218         // Counter overflow is incredibly unrealistic.
219         unchecked {
220             balanceOf[to]++;
221         }
222 
223         ownerOf[id] = to;
224 
225         emit Transfer(address(0), to, id);
226     }
227 
228     function _burn(uint256 id) internal virtual {
229         address owner = ownerOf[id];
230 
231         require(ownerOf[id] != address(0), "NOT_MINTED");
232 
233         // Ownership check above ensures no underflow.
234         unchecked {
235             balanceOf[owner]--;
236         }
237 
238         delete ownerOf[id];
239 
240         delete getApproved[id];
241 
242         emit Transfer(owner, address(0), id);
243     }
244 
245     /*///////////////////////////////////////////////////////////////
246                        INTERNAL SAFE MINT LOGIC
247     //////////////////////////////////////////////////////////////*/
248 
249     function _safeMint(address to, uint256 id) internal virtual {
250         _mint(to, id);
251 
252         require(
253             to.code.length == 0 ||
254                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
255                 ERC721TokenReceiver.onERC721Received.selector,
256             "UNSAFE_RECIPIENT"
257         );
258     }
259 
260     function _safeMint(
261         address to,
262         uint256 id,
263         bytes memory data
264     ) internal virtual {
265         _mint(to, id);
266 
267         require(
268             to.code.length == 0 ||
269                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
270                 ERC721TokenReceiver.onERC721Received.selector,
271             "UNSAFE_RECIPIENT"
272         );
273     }
274 }
275 
276 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
277 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
278 interface ERC721TokenReceiver {
279     function onERC721Received(
280         address operator,
281         address from,
282         uint256 id,
283         bytes calldata data
284     ) external returns (bytes4);
285 }
286 
287 
288 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
289 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
290 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
291 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
292 abstract contract ERC20 {
293     /*///////////////////////////////////////////////////////////////
294                                   EVENTS
295     //////////////////////////////////////////////////////////////*/
296 
297     event Transfer(address indexed from, address indexed to, uint256 amount);
298 
299     event Approval(address indexed owner, address indexed spender, uint256 amount);
300 
301     /*///////////////////////////////////////////////////////////////
302                              METADATA STORAGE
303     //////////////////////////////////////////////////////////////*/
304 
305     string public name;
306 
307     string public symbol;
308 
309     uint8 public immutable decimals;
310 
311     /*///////////////////////////////////////////////////////////////
312                               ERC20 STORAGE
313     //////////////////////////////////////////////////////////////*/
314 
315     uint256 public totalSupply;
316 
317     mapping(address => uint256) public balanceOf;
318 
319     mapping(address => mapping(address => uint256)) public allowance;
320 
321     /*///////////////////////////////////////////////////////////////
322                              EIP-2612 STORAGE
323     //////////////////////////////////////////////////////////////*/
324 
325     bytes32 public constant PERMIT_TYPEHASH =
326         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
327 
328     uint256 internal immutable INITIAL_CHAIN_ID;
329 
330     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
331 
332     mapping(address => uint256) public nonces;
333 
334     /*///////////////////////////////////////////////////////////////
335                                CONSTRUCTOR
336     //////////////////////////////////////////////////////////////*/
337 
338     constructor(
339         string memory _name,
340         string memory _symbol,
341         uint8 _decimals
342     ) {
343         name = _name;
344         symbol = _symbol;
345         decimals = _decimals;
346 
347         INITIAL_CHAIN_ID = block.chainid;
348         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
349     }
350 
351     /*///////////////////////////////////////////////////////////////
352                               ERC20 LOGIC
353     //////////////////////////////////////////////////////////////*/
354 
355     function approve(address spender, uint256 amount) public virtual returns (bool) {
356         allowance[msg.sender][spender] = amount;
357 
358         emit Approval(msg.sender, spender, amount);
359 
360         return true;
361     }
362 
363     function transfer(address to, uint256 amount) public virtual returns (bool) {
364         balanceOf[msg.sender] -= amount;
365 
366         // Cannot overflow because the sum of all user
367         // balances can't exceed the max uint256 value.
368         unchecked {
369             balanceOf[to] += amount;
370         }
371 
372         emit Transfer(msg.sender, to, amount);
373 
374         return true;
375     }
376 
377     function transferFrom(
378         address from,
379         address to,
380         uint256 amount
381     ) public virtual returns (bool) {
382         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
383 
384         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
385 
386         balanceOf[from] -= amount;
387 
388         // Cannot overflow because the sum of all user
389         // balances can't exceed the max uint256 value.
390         unchecked {
391             balanceOf[to] += amount;
392         }
393 
394         emit Transfer(from, to, amount);
395 
396         return true;
397     }
398 
399     /*///////////////////////////////////////////////////////////////
400                               EIP-2612 LOGIC
401     //////////////////////////////////////////////////////////////*/
402 
403     function permit(
404         address owner,
405         address spender,
406         uint256 value,
407         uint256 deadline,
408         uint8 v,
409         bytes32 r,
410         bytes32 s
411     ) public virtual {
412         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
413 
414         // Unchecked because the only math done is incrementing
415         // the owner's nonce which cannot realistically overflow.
416         unchecked {
417             bytes32 digest = keccak256(
418                 abi.encodePacked(
419                     "\x19\x01",
420                     DOMAIN_SEPARATOR(),
421                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
422                 )
423             );
424 
425             address recoveredAddress = ecrecover(digest, v, r, s);
426 
427             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
428 
429             allowance[recoveredAddress][spender] = value;
430         }
431 
432         emit Approval(owner, spender, value);
433     }
434 
435     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
436         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
437     }
438 
439     function computeDomainSeparator() internal view virtual returns (bytes32) {
440         return
441             keccak256(
442                 abi.encode(
443                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
444                     keccak256(bytes(name)),
445                     keccak256("1"),
446                     block.chainid,
447                     address(this)
448                 )
449             );
450     }
451 
452     /*///////////////////////////////////////////////////////////////
453                        INTERNAL MINT/BURN LOGIC
454     //////////////////////////////////////////////////////////////*/
455 
456     function _mint(address to, uint256 amount) internal virtual {
457         totalSupply += amount;
458 
459         // Cannot overflow because the sum of all user
460         // balances can't exceed the max uint256 value.
461         unchecked {
462             balanceOf[to] += amount;
463         }
464 
465         emit Transfer(address(0), to, amount);
466     }
467 
468     function _burn(address from, uint256 amount) internal virtual {
469         balanceOf[from] -= amount;
470 
471         // Cannot underflow because a user's balance
472         // will never be larger than the total supply.
473         unchecked {
474             totalSupply -= amount;
475         }
476 
477         emit Transfer(from, address(0), amount);
478     }
479 }
480 
481 
482 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
483 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
484 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
485 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
486 library SafeTransferLib {
487     /*///////////////////////////////////////////////////////////////
488                             ETH OPERATIONS
489     //////////////////////////////////////////////////////////////*/
490 
491     function safeTransferETH(address to, uint256 amount) internal {
492         bool callStatus;
493 
494         assembly {
495             // Transfer the ETH and store if it succeeded or not.
496             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
497         }
498 
499         require(callStatus, "ETH_TRANSFER_FAILED");
500     }
501 
502     /*///////////////////////////////////////////////////////////////
503                            ERC20 OPERATIONS
504     //////////////////////////////////////////////////////////////*/
505 
506     function safeTransferFrom(
507         ERC20 token,
508         address from,
509         address to,
510         uint256 amount
511     ) internal {
512         bool callStatus;
513 
514         assembly {
515             // Get a pointer to some free memory.
516             let freeMemoryPointer := mload(0x40)
517 
518             // Write the abi-encoded calldata to memory piece by piece:
519             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
520             mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "from" argument.
521             mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
522             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
523 
524             // Call the token and store if it succeeded or not.
525             // We use 100 because the calldata length is 4 + 32 * 3.
526             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
527         }
528 
529         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FROM_FAILED");
530     }
531 
532     function safeTransfer(
533         ERC20 token,
534         address to,
535         uint256 amount
536     ) internal {
537         bool callStatus;
538 
539         assembly {
540             // Get a pointer to some free memory.
541             let freeMemoryPointer := mload(0x40)
542 
543             // Write the abi-encoded calldata to memory piece by piece:
544             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
545             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
546             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
547 
548             // Call the token and store if it succeeded or not.
549             // We use 68 because the calldata length is 4 + 32 * 2.
550             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
551         }
552 
553         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FAILED");
554     }
555 
556     function safeApprove(
557         ERC20 token,
558         address to,
559         uint256 amount
560     ) internal {
561         bool callStatus;
562 
563         assembly {
564             // Get a pointer to some free memory.
565             let freeMemoryPointer := mload(0x40)
566 
567             // Write the abi-encoded calldata to memory piece by piece:
568             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
569             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
570             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
571 
572             // Call the token and store if it succeeded or not.
573             // We use 68 because the calldata length is 4 + 32 * 2.
574             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
575         }
576 
577         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
578     }
579 
580     /*///////////////////////////////////////////////////////////////
581                          INTERNAL HELPER LOGIC
582     //////////////////////////////////////////////////////////////*/
583 
584     function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool success) {
585         assembly {
586             // Get how many bytes the call returned.
587             let returnDataSize := returndatasize()
588 
589             // If the call reverted:
590             if iszero(callStatus) {
591                 // Copy the revert message into memory.
592                 returndatacopy(0, 0, returnDataSize)
593 
594                 // Revert with the same message.
595                 revert(0, returnDataSize)
596             }
597 
598             switch returnDataSize
599             case 32 {
600                 // Copy the return data into memory.
601                 returndatacopy(0, 0, returnDataSize)
602 
603                 // Set success to whether it returned true.
604                 success := iszero(iszero(mload(0)))
605             }
606             case 0 {
607                 // There was no return data.
608                 success := 1
609             }
610             default {
611                 // It returned some malformed input.
612                 success := 0
613             }
614         }
615     }
616 }
617 
618 
619 /// @notice Arithmetic library with operations for fixed-point numbers.
620 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/FixedPointMathLib.sol)
621 library FixedPointMathLib {
622     /*///////////////////////////////////////////////////////////////
623                             COMMON BASE UNITS
624     //////////////////////////////////////////////////////////////*/
625 
626     uint256 internal constant YAD = 1e8;
627     uint256 internal constant WAD = 1e18;
628     uint256 internal constant RAY = 1e27;
629     uint256 internal constant RAD = 1e45;
630 
631     /*///////////////////////////////////////////////////////////////
632                          FIXED POINT OPERATIONS
633     //////////////////////////////////////////////////////////////*/
634 
635     function fmul(
636         uint256 x,
637         uint256 y,
638         uint256 baseUnit
639     ) internal pure returns (uint256 z) {
640         assembly {
641             // Store x * y in z for now.
642             z := mul(x, y)
643 
644             // Equivalent to require(x == 0 || (x * y) / x == y)
645             if iszero(or(iszero(x), eq(div(z, x), y))) {
646                 revert(0, 0)
647             }
648 
649             // If baseUnit is zero this will return zero instead of reverting.
650             z := div(z, baseUnit)
651         }
652     }
653 
654     function fdiv(
655         uint256 x,
656         uint256 y,
657         uint256 baseUnit
658     ) internal pure returns (uint256 z) {
659         assembly {
660             // Store x * baseUnit in z for now.
661             z := mul(x, baseUnit)
662 
663             // Equivalent to require(y != 0 && (x == 0 || (x * baseUnit) / x == baseUnit))
664             if iszero(and(iszero(iszero(y)), or(iszero(x), eq(div(z, x), baseUnit)))) {
665                 revert(0, 0)
666             }
667 
668             // We ensure y is not zero above, so there is never division by zero here.
669             z := div(z, y)
670         }
671     }
672 
673     function fpow(
674         uint256 x,
675         uint256 n,
676         uint256 baseUnit
677     ) internal pure returns (uint256 z) {
678         assembly {
679             switch x
680             case 0 {
681                 switch n
682                 case 0 {
683                     // 0 ** 0 = 1
684                     z := baseUnit
685                 }
686                 default {
687                     // 0 ** n = 0
688                     z := 0
689                 }
690             }
691             default {
692                 switch mod(n, 2)
693                 case 0 {
694                     // If n is even, store baseUnit in z for now.
695                     z := baseUnit
696                 }
697                 default {
698                     // If n is odd, store x in z for now.
699                     z := x
700                 }
701 
702                 // Shifting right by 1 is like dividing by 2.
703                 let half := shr(1, baseUnit)
704 
705                 for {
706                     // Shift n right by 1 before looping to halve it.
707                     n := shr(1, n)
708                 } n {
709                     // Shift n right by 1 each iteration to halve it.
710                     n := shr(1, n)
711                 } {
712                     // Revert immediately if x ** 2 would overflow.
713                     // Equivalent to iszero(eq(div(xx, x), x)) here.
714                     if shr(128, x) {
715                         revert(0, 0)
716                     }
717 
718                     // Store x squared.
719                     let xx := mul(x, x)
720 
721                     // Round to the nearest number.
722                     let xxRound := add(xx, half)
723 
724                     // Revert if xx + half overflowed.
725                     if lt(xxRound, xx) {
726                         revert(0, 0)
727                     }
728 
729                     // Set x to scaled xxRound.
730                     x := div(xxRound, baseUnit)
731 
732                     // If n is even:
733                     if mod(n, 2) {
734                         // Compute z * x.
735                         let zx := mul(z, x)
736 
737                         // If z * x overflowed:
738                         if iszero(eq(div(zx, x), z)) {
739                             // Revert if x is non-zero.
740                             if iszero(iszero(x)) {
741                                 revert(0, 0)
742                             }
743                         }
744 
745                         // Round to the nearest number.
746                         let zxRound := add(zx, half)
747 
748                         // Revert if zx + half overflowed.
749                         if lt(zxRound, zx) {
750                             revert(0, 0)
751                         }
752 
753                         // Return properly scaled zxRound.
754                         z := div(zxRound, baseUnit)
755                     }
756                 }
757             }
758         }
759     }
760 
761     /*///////////////////////////////////////////////////////////////
762                         GENERAL NUMBER UTILITIES
763     //////////////////////////////////////////////////////////////*/
764 
765     function sqrt(uint256 x) internal pure returns (uint256 z) {
766         assembly {
767             // Start off with z at 1.
768             z := 1
769 
770             // Used below to help find a nearby power of 2.
771             let y := x
772 
773             // Find the lowest power of 2 that is at least sqrt(x).
774             if iszero(lt(y, 0x100000000000000000000000000000000)) {
775                 y := shr(128, y) // Like dividing by 2 ** 128.
776                 z := shl(64, z)
777             }
778             if iszero(lt(y, 0x10000000000000000)) {
779                 y := shr(64, y) // Like dividing by 2 ** 64.
780                 z := shl(32, z)
781             }
782             if iszero(lt(y, 0x100000000)) {
783                 y := shr(32, y) // Like dividing by 2 ** 32.
784                 z := shl(16, z)
785             }
786             if iszero(lt(y, 0x10000)) {
787                 y := shr(16, y) // Like dividing by 2 ** 16.
788                 z := shl(8, z)
789             }
790             if iszero(lt(y, 0x100)) {
791                 y := shr(8, y) // Like dividing by 2 ** 8.
792                 z := shl(4, z)
793             }
794             if iszero(lt(y, 0x10)) {
795                 y := shr(4, y) // Like dividing by 2 ** 4.
796                 z := shl(2, z)
797             }
798             if iszero(lt(y, 0x8)) {
799                 // Equivalent to 2 ** z.
800                 z := shl(1, z)
801             }
802 
803             // Shifting right by 1 is like dividing by 2.
804             z := shr(1, add(z, div(x, z)))
805             z := shr(1, add(z, div(x, z)))
806             z := shr(1, add(z, div(x, z)))
807             z := shr(1, add(z, div(x, z)))
808             z := shr(1, add(z, div(x, z)))
809             z := shr(1, add(z, div(x, z)))
810             z := shr(1, add(z, div(x, z)))
811 
812             // Compute a rounded down version of z.
813             let zRoundDown := div(x, z)
814 
815             // If zRoundDown is smaller, use it.
816             if lt(zRoundDown, z) {
817                 z := zRoundDown
818             }
819         }
820     }
821 }
822 
823 
824 /*
825  ____       _               ____                     ____ _       _
826 |  _ \ ___ | | _____ _ __  |  _ \  ___   __ _ ___   / ___| |_   _| |__
827 | |_) / _ \| |/ / _ \ '__| | | | |/ _ \ / _` / __| | |   | | | | | '_ \
828 |  __/ (_) |   <  __/ |    | |_| | (_) | (_| \__ \ | |___| | |_| | |_) |
829 |_|   \___/|_|\_\___|_|    |____/ \___/ \__, |___/  \____|_|\__,_|_.__/
830                                         |___/
831 */
832 
833 error DoesNotExist();
834 error NoTokensLeft();
835 error NotEnoughETH();
836 error TooManyMintAtOnce();
837 error NotOnWhitelist();
838 error WhitelistMintNotStarted();
839 error MintNotStarted();
840 error EmptyBalance();
841 error NoReserveTokensLeft();
842 
843 contract PokerDogsClub is LilOwnable, ERC721 {
844     using Strings for uint256;
845 
846     uint256 public constant TOTAL_SUPPLY = 7777;
847     uint256 public constant PRICE_PER_WHITELIST_MINT = 0.05 ether;
848     uint256 public constant PRICE_PER_PUBLIC_MINT = 0.069 ether;
849     uint256 public maxWhitelistMintAmount = 10;
850     uint256 public maxPublicMintAmount = 20;
851 
852     bool public whitelistMintStarted = false;
853     bool public mintStarted = false;
854     bool public revealed = false;
855 
856     uint256 public totalSupply;
857 
858     bytes32 private _merkleRoot;
859 
860     string public baseURI;
861     string public nonRevealedURI;
862     string public baseExtension = ".json";
863 
864     address[4] private _royaltyAddresses;
865 
866     mapping(address => uint256) private _royaltyShares;
867 
868     constructor(
869         string memory _nonRevealedURI,
870         bytes32 _initMerkleRoot,
871         address[4] memory _contributorAddresses
872     ) payable ERC721("Poker Dogs Club", "PDGC") {
873         nonRevealedURI = _nonRevealedURI;
874         _merkleRoot = _initMerkleRoot;
875 
876         _royaltyAddresses[0] = _contributorAddresses[0];
877         _royaltyAddresses[1] = _contributorAddresses[1];
878         _royaltyAddresses[2] = _contributorAddresses[2];
879         _royaltyAddresses[3] = _contributorAddresses[3];
880 
881         _royaltyShares[_royaltyAddresses[0]] = 515;
882         _royaltyShares[_royaltyAddresses[1]] = 400;
883         _royaltyShares[_royaltyAddresses[2]] = 75;
884         _royaltyShares[_royaltyAddresses[3]] = 10;
885         for (uint256 i=0; i < 50; i++) {
886             _mint(msg.sender, totalSupply + 1);
887             totalSupply++;
888         }
889     }
890     
891     modifier onlyOwner() {
892         require(msg.sender == _owner, "Ownable: caller is not the owner");
893         _;
894     }
895 
896     /// @dev    Add a hashed address to the merkle tree as a leaf
897     /// @param  account Leaf address for MerkleTree
898     /// @return bytes32 hashed version of the merkle leaf address
899     function _leaf(address account) private pure returns (bytes32) {
900         return keccak256(abi.encodePacked(account));
901     }
902 
903     /// @dev    Verify the whitelist using the merkle tree
904     /// @param  leaf Hashed address leaf from _leaf() to search for
905     /// @param  proof Submitted root proof from MerkleTree
906     /// @return bool True if address is allowed to mint
907     function verifyWhitelist(bytes32 leaf, bytes32[] memory proof)
908         private
909         view
910         returns (bool)
911     {
912         bytes32 computedHash = leaf;
913 
914         for (uint256 i = 0; i < proof.length; i++) {
915             bytes32 proofElement = proof[i];
916 
917             if (computedHash < proofElement) {
918                 computedHash = keccak256(
919                     abi.encodePacked(computedHash, proofElement)
920                 );
921             } else {
922                 computedHash = keccak256(
923                     abi.encodePacked(proofElement, computedHash)
924                 );
925             }
926         }
927 
928         return computedHash == _merkleRoot;
929     }
930 
931     function mint(uint16 amount) external payable {
932         if (totalSupply + amount > TOTAL_SUPPLY) revert NoTokensLeft();
933         if (!mintStarted) revert MintNotStarted();
934         if (msg.value < amount * PRICE_PER_PUBLIC_MINT) revert NotEnoughETH();
935         if (amount > maxPublicMintAmount) revert TooManyMintAtOnce();
936 
937         unchecked {
938             for (uint16 index = 0; index < amount; index++) {
939                 _mint(msg.sender, totalSupply + 1);
940                 totalSupply++;
941             }
942         }
943     }
944 
945     function whitelistMint(uint16 amount, bytes32[] memory _proof) external payable {
946         if (totalSupply + amount > TOTAL_SUPPLY) revert NoTokensLeft();
947         if (!whitelistMintStarted) revert WhitelistMintNotStarted();
948         if (msg.value < amount * PRICE_PER_WHITELIST_MINT) revert NotEnoughETH();
949         if (amount > maxWhitelistMintAmount) revert TooManyMintAtOnce();
950         if (verifyWhitelist(_leaf(msg.sender), _proof) == false) revert NotOnWhitelist();
951         
952         unchecked {
953             for (uint16 index = 0; index < amount; index++) {
954                 _mint(msg.sender, totalSupply + 1);
955                 totalSupply++;
956             }
957         }
958     }
959 
960     function tokenURI(uint256 id) public view virtual override returns (string memory) {
961         if (ownerOf[id] == address(0)) revert DoesNotExist();
962 
963         if (revealed == false) {
964             return nonRevealedURI;
965         }
966         return string(abi.encodePacked(baseURI, id.toString(), baseExtension));
967     }
968 
969     function setBaseURI(string memory _newBaseURI) public onlyOwner {
970         baseURI = _newBaseURI;
971     }
972 
973     function startWhitelistMint() public onlyOwner {
974         whitelistMintStarted = true;
975     }
976     
977     function startMint() public onlyOwner {
978         mintStarted = true;
979     }
980 
981     function pauseMint() public onlyOwner {
982         whitelistMintStarted = false;
983         mintStarted = false;
984     }
985 
986     function reveal(string memory _baseUri) public onlyOwner {
987         setBaseURI(_baseUri);
988         revealed = true;
989     }
990 
991     function setMerkleRoot(bytes32 _merkleRootValue) external onlyOwner returns (bytes32) {
992         _merkleRoot = _merkleRootValue;
993         return _merkleRoot;
994     }
995 
996     function withdraw() external onlyOwner {
997         if (address(this).balance == 0) revert EmptyBalance();
998         uint256 balance = address(this).balance;
999 
1000         for (uint256 i = 0; i < _royaltyAddresses.length; i++) {
1001             payable(_royaltyAddresses[i]).transfer(
1002                 balance / 1000 * _royaltyShares[_royaltyAddresses[i]]
1003             );
1004         }
1005     }
1006 
1007     /// @dev Tells interfacing contracts what they can do with this one
1008     function supportsInterface(bytes4 interfaceId)
1009         public
1010         pure
1011         override(LilOwnable, ERC721)
1012         returns (bool)
1013     {
1014         return
1015             interfaceId == 0x7f5828d0 || // ERC165 Interface ID for ERC173
1016             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
1017             interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC165
1018             interfaceId == 0x01ffc9a7; // ERC165 Interface ID for ERC721Metadata
1019     }
1020 }