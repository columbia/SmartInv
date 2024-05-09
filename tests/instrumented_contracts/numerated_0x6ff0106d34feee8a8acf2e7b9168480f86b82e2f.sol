1 // SPDX-License-Identifier: WTFPL
2 pragma solidity >=0.8.0;
3 
4 
5 
6 /**
7 
8      ██████╗ ██████╗ ███╗   ██╗ ██████╗ █████╗ ██╗   ██╗██████╗
9     ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║   ██║╚════██╗
10     ██║     ██║   ██║██╔██╗ ██║██║     ███████║██║   ██║ █████╔╝
11     ██║     ██║   ██║██║╚██╗██║██║     ██╔══██║╚██╗ ██╔╝ ╚═══██╗
12     ╚██████╗╚██████╔╝██║ ╚████║╚██████╗██║  ██║ ╚████╔╝ ██████╔╝
13      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═════╝
14 
15     Concave A Token
16 
17 */
18 
19 /* -------------------------------------------------------------------------- */
20 /*                                   IMPORTS                                  */
21 /* -------------------------------------------------------------------------- */
22 
23 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
24 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
25 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
26 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
27 abstract contract ERC20 {
28     /*///////////////////////////////////////////////////////////////
29                                   EVENTS
30     //////////////////////////////////////////////////////////////*/
31 
32     event Transfer(address indexed from, address indexed to, uint256 amount);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 amount);
35 
36     /*///////////////////////////////////////////////////////////////
37                              METADATA STORAGE
38     //////////////////////////////////////////////////////////////*/
39 
40     string public name;
41 
42     string public symbol;
43 
44     uint8 public immutable decimals;
45 
46     /*///////////////////////////////////////////////////////////////
47                               ERC20 STORAGE
48     //////////////////////////////////////////////////////////////*/
49 
50     uint256 public totalSupply;
51 
52     mapping(address => uint256) public balanceOf;
53 
54     mapping(address => mapping(address => uint256)) public allowance;
55 
56     /*///////////////////////////////////////////////////////////////
57                              EIP-2612 STORAGE
58     //////////////////////////////////////////////////////////////*/
59 
60     bytes32 public constant PERMIT_TYPEHASH =
61         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
62 
63     uint256 internal immutable INITIAL_CHAIN_ID;
64 
65     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
66 
67     mapping(address => uint256) public nonces;
68 
69     /*///////////////////////////////////////////////////////////////
70                                CONSTRUCTOR
71     //////////////////////////////////////////////////////////////*/
72 
73     constructor(
74         string memory _name,
75         string memory _symbol,
76         uint8 _decimals
77     ) {
78         name = _name;
79         symbol = _symbol;
80         decimals = _decimals;
81 
82         INITIAL_CHAIN_ID = block.chainid;
83         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
84     }
85 
86     /*///////////////////////////////////////////////////////////////
87                               ERC20 LOGIC
88     //////////////////////////////////////////////////////////////*/
89 
90     function approve(address spender, uint256 amount) public virtual returns (bool) {
91         allowance[msg.sender][spender] = amount;
92 
93         emit Approval(msg.sender, spender, amount);
94 
95         return true;
96     }
97 
98     function transfer(address to, uint256 amount) public virtual returns (bool) {
99         balanceOf[msg.sender] -= amount;
100 
101         // Cannot overflow because the sum of all user
102         // balances can't exceed the max uint256 value.
103         unchecked {
104             balanceOf[to] += amount;
105         }
106 
107         emit Transfer(msg.sender, to, amount);
108 
109         return true;
110     }
111 
112     function transferFrom(
113         address from,
114         address to,
115         uint256 amount
116     ) public virtual returns (bool) {
117         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
118 
119         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
120 
121         balanceOf[from] -= amount;
122 
123         // Cannot overflow because the sum of all user
124         // balances can't exceed the max uint256 value.
125         unchecked {
126             balanceOf[to] += amount;
127         }
128 
129         emit Transfer(from, to, amount);
130 
131         return true;
132     }
133 
134     /*///////////////////////////////////////////////////////////////
135                               EIP-2612 LOGIC
136     //////////////////////////////////////////////////////////////*/
137 
138     function permit(
139         address owner,
140         address spender,
141         uint256 value,
142         uint256 deadline,
143         uint8 v,
144         bytes32 r,
145         bytes32 s
146     ) public virtual {
147         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
148 
149         // Unchecked because the only math done is incrementing
150         // the owner's nonce which cannot realistically overflow.
151         unchecked {
152             bytes32 digest = keccak256(
153                 abi.encodePacked(
154                     "\x19\x01",
155                     DOMAIN_SEPARATOR(),
156                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
157                 )
158             );
159 
160             address recoveredAddress = ecrecover(digest, v, r, s);
161 
162             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
163 
164             allowance[recoveredAddress][spender] = value;
165         }
166 
167         emit Approval(owner, spender, value);
168     }
169 
170     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
171         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
172     }
173 
174     function computeDomainSeparator() internal view virtual returns (bytes32) {
175         return
176             keccak256(
177                 abi.encode(
178                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
179                     keccak256(bytes(name)),
180                     keccak256("1"),
181                     block.chainid,
182                     address(this)
183                 )
184             );
185     }
186 
187     /*///////////////////////////////////////////////////////////////
188                        INTERNAL MINT/BURN LOGIC
189     //////////////////////////////////////////////////////////////*/
190 
191     function _mint(address to, uint256 amount) internal virtual {
192         totalSupply += amount;
193 
194         // Cannot overflow because the sum of all user
195         // balances can't exceed the max uint256 value.
196         unchecked {
197             balanceOf[to] += amount;
198         }
199 
200         emit Transfer(address(0), to, amount);
201     }
202 
203     function _burn(address from, uint256 amount) internal virtual {
204         balanceOf[from] -= amount;
205 
206         // Cannot underflow because a user's balance
207         // will never be larger than the total supply.
208         unchecked {
209             totalSupply -= amount;
210         }
211 
212         emit Transfer(from, address(0), amount);
213     }
214 }
215 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
216 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
217 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
218 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
219 library SafeTransferLib {
220     /*///////////////////////////////////////////////////////////////
221                             ETH OPERATIONS
222     //////////////////////////////////////////////////////////////*/
223 
224     function safeTransferETH(address to, uint256 amount) internal {
225         bool callStatus;
226 
227         assembly {
228             // Transfer the ETH and store if it succeeded or not.
229             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
230         }
231 
232         require(callStatus, "ETH_TRANSFER_FAILED");
233     }
234 
235     /*///////////////////////////////////////////////////////////////
236                            ERC20 OPERATIONS
237     //////////////////////////////////////////////////////////////*/
238 
239     function safeTransferFrom(
240         ERC20 token,
241         address from,
242         address to,
243         uint256 amount
244     ) internal {
245         bool callStatus;
246 
247         assembly {
248             // Get a pointer to some free memory.
249             let freeMemoryPointer := mload(0x40)
250 
251             // Write the abi-encoded calldata to memory piece by piece:
252             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
253             mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "from" argument.
254             mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
255             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
256 
257             // Call the token and store if it succeeded or not.
258             // We use 100 because the calldata length is 4 + 32 * 3.
259             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
260         }
261 
262         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FROM_FAILED");
263     }
264 
265     function safeTransfer(
266         ERC20 token,
267         address to,
268         uint256 amount
269     ) internal {
270         bool callStatus;
271 
272         assembly {
273             // Get a pointer to some free memory.
274             let freeMemoryPointer := mload(0x40)
275 
276             // Write the abi-encoded calldata to memory piece by piece:
277             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
278             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
279             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
280 
281             // Call the token and store if it succeeded or not.
282             // We use 68 because the calldata length is 4 + 32 * 2.
283             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
284         }
285 
286         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FAILED");
287     }
288 
289     function safeApprove(
290         ERC20 token,
291         address to,
292         uint256 amount
293     ) internal {
294         bool callStatus;
295 
296         assembly {
297             // Get a pointer to some free memory.
298             let freeMemoryPointer := mload(0x40)
299 
300             // Write the abi-encoded calldata to memory piece by piece:
301             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
302             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
303             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
304 
305             // Call the token and store if it succeeded or not.
306             // We use 68 because the calldata length is 4 + 32 * 2.
307             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
308         }
309 
310         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
311     }
312 
313     /*///////////////////////////////////////////////////////////////
314                          INTERNAL HELPER LOGIC
315     //////////////////////////////////////////////////////////////*/
316 
317     function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool success) {
318         assembly {
319             // Get how many bytes the call returned.
320             let returnDataSize := returndatasize()
321 
322             // If the call reverted:
323             if iszero(callStatus) {
324                 // Copy the revert message into memory.
325                 returndatacopy(0, 0, returnDataSize)
326 
327                 // Revert with the same message.
328                 revert(0, returnDataSize)
329             }
330 
331             switch returnDataSize
332             case 32 {
333                 // Copy the return data into memory.
334                 returndatacopy(0, 0, returnDataSize)
335 
336                 // Set success to whether it returned true.
337                 success := iszero(iszero(mload(0)))
338             }
339             case 0 {
340                 // There was no return data.
341                 success := 1
342             }
343             default {
344                 // It returned some malformed input.
345                 success := 0
346             }
347         }
348     }
349 }
350 /**
351  * @dev These functions deal with verification of Merkle Trees proofs.
352  *
353  * The proofs can be generated using the JavaScript library
354  * https://github.com/miguelmota/merkletreejs[merkletreejs].
355  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
356  *
357  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
358  */
359 library MerkleProof {
360     /**
361      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
362      * defined by `root`. For this, a `proof` must be provided, containing
363      * sibling hashes on the branch from the leaf to the root of the tree. Each
364      * pair of leaves and each pair of pre-images are assumed to be sorted.
365      */
366     function verify(
367         bytes32[] memory proof,
368         bytes32 root,
369         bytes32 leaf
370     ) internal pure returns (bool) {
371         return processProof(proof, leaf) == root;
372     }
373 
374     /**
375      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
376      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
377      * hash matches the root of the tree. When processing the proof, the pairs
378      * of leafs & pre-images are assumed to be sorted.
379      *
380      * _Available since v4.4._
381      */
382     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
383         bytes32 computedHash = leaf;
384         for (uint256 i = 0; i < proof.length; i++) {
385             bytes32 proofElement = proof[i];
386             if (computedHash <= proofElement) {
387                 // Hash(current computed hash + current element of the proof)
388                 computedHash = _efficientHash(computedHash, proofElement);
389             } else {
390                 // Hash(current element of the proof + current computed hash)
391                 computedHash = _efficientHash(proofElement, computedHash);
392             }
393         }
394         return computedHash;
395     }
396 
397     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
398         assembly {
399             mstore(0x00, a)
400             mstore(0x20, b)
401             value := keccak256(0x00, 0x40)
402         }
403     }
404 }
405 /// @notice Concave A Token
406 /// @author 0xBarista & Dionysus (ConcaveFi)
407 contract aCNV is ERC20("Concave A Token (aCNV)", "aCNV", 18) {
408 
409     /* ---------------------------------------------------------------------- */
410     /*                                DEPENDENCIES                            */
411     /* ---------------------------------------------------------------------- */
412 
413     using SafeTransferLib for ERC20;
414 
415     /* ---------------------------------------------------------------------- */
416     /*                             IMMUTABLE STATE                            */
417     /* ---------------------------------------------------------------------- */
418 
419     /// @notice FRAX tokenIn address
420     ERC20 public immutable FRAX = ERC20(0x853d955aCEf822Db058eb8505911ED77F175b99e);
421 
422     /// @notice DAI tokenIn address
423     ERC20 public immutable DAI = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
424 
425     /// @notice Error related to amount
426     string constant AMOUNT_ERROR = "!AMOUNT";
427 
428     /// @notice Error related to token address
429     string constant TOKEN_IN_ERROR = "!TOKEN_IN";
430 
431     /// @notice Error minting exceeds supply
432     string constant EXCEEDS_SUPPLY = "EXCEEDS_SUPPLY";
433 
434     /// @notice Error transfers paused
435     string constant PAUSED = "PAUSED";
436 
437     /* ---------------------------------------------------------------------- */
438     /*                              MUTABLE STATE                             */
439     /* ---------------------------------------------------------------------- */
440 
441     /// @notice Address that is recipient of raised funds + access control
442     address public treasury = 0x226e7AF139a0F34c6771DeB252F9988876ac1Ced;
443 
444     /// @notice Returns the current merkle root being used
445     bytes32 public merkleRoot;
446 
447     /// @notice Returns an array of all merkle roots used
448     bytes32[] public roots;
449 
450     /// @notice Returns the current pCNV price in DAI/FRAX
451     uint256 public rate;
452 
453     /// @notice Returns the max supply of pCNV that is allowed to be minted (in total)
454     uint256 public maxSupply = 333_000 * 1e18;
455 
456     /// @notice Returns the total amount of pCNV that has cumulatively been minted
457     uint256 public totalMinted;
458 
459     /// @notice Returns whether transfers are paused
460     bool public transfersPaused = true;
461 
462     /* ---------------------------------------------------------------------- */
463     /*                              STRUCTURED STATE                          */
464     /* ---------------------------------------------------------------------- */
465 
466     /// @notice Structure of Participant vesting storage
467     struct Participant {
468         uint256 purchased; // amount (in total) of pCNV that user has purchased
469         uint256 redeemed;  // amount (in total) of pCNV that user has redeemed
470     }
471 
472     /// @notice             maps an account to vesting storage
473     /// address             - account to check
474     /// returns Participant - Structured vesting storage
475     mapping(address => Participant) public participants;
476 
477     /// @notice             amount of DAI/FRAX user has spent for a specific root
478     /// bytes32             - merkle root
479     /// address             - account to check
480     /// returns uint256     - amount in DAI/FRAX (denominated in ether) spent purchasing pCNV
481     mapping(bytes32 => mapping(address => uint256)) public spentAmounts;
482 
483     /* ---------------------------------------------------------------------- */
484     /*                                  EVENTS                                */
485     /* ---------------------------------------------------------------------- */
486 
487     /// @notice Emitted when treasury changes treasury address
488     /// @param  treasury address of new treasury
489     event TreasurySet(address treasury);
490 
491     /// @notice             Emitted when a new round is set by treasury
492     /// @param  merkleRoot  new merkle root
493     /// @param  rate        new price of pCNV in DAI/FRAX
494     event NewRound(bytes32 merkleRoot, uint256 rate);
495 
496     /// @notice             Emitted when maxSupply of pCNV is burned or minted to target
497     /// @param  target      target to which to mint pCNV or burn if target = address(0)
498     /// @param  amount      amount of pCNV minted to target or burned
499     /// @param  totalMinted amount of pCNV minted to target or burned
500     event Managed(address target, uint256 amount, uint256 totalMinted);
501 
502     /// @notice                 Emitted when pCNV minted via "mint()" or "mintWithPermit"
503     /// @param  depositedFrom   address from which DAI/FRAX was deposited
504     /// @param  mintedTo        address to which pCNV were minted to
505     /// @param  amount          amount of pCNV minted
506     /// @param  deposited       amount of DAI/FRAX deposited
507     /// @param  totalMinted     total amount of pCNV minted so far
508     event Minted(
509         address indexed depositedFrom,
510         address indexed mintedTo,
511         uint256 amount,
512         uint256 deposited,
513         uint256 totalMinted
514     );
515 
516     /// @notice                 Emitted when Concave changes max supply
517     /// @param  oldMax          old max supply
518     /// @param  newMax          new max supply
519     event SupplyChanged(uint256 oldMax, uint256 newMax);
520 
521     /* ---------------------------------------------------------------------- */
522     /*                                MODIFIERS                               */
523     /* ---------------------------------------------------------------------- */
524 
525     /// @notice only allows Concave treasury
526     modifier onlyConcave() {
527         require(msg.sender == treasury, "!CONCAVE");
528         _;
529     }
530 
531     /* ---------------------------------------------------------------------- */
532     /*                              ONLY CONCAVE                              */
533     /* ---------------------------------------------------------------------- */
534 
535     /// @notice Set a new treasury address if treasury
536     function setTreasury(
537         address _treasury
538     ) external onlyConcave {
539         treasury = _treasury;
540         emit TreasurySet(_treasury);
541     }
542 
543     /// @notice             Update merkle root and rate
544     /// @param _merkleRoot  root of merkle tree
545     /// @param _rate        price of pCNV in DAI/FRAX
546     function setRound(
547         bytes32 _merkleRoot,
548         uint256 _rate
549     ) external onlyConcave {
550         // push new root to array of all roots - for viewing
551         roots.push(_merkleRoot);
552         // update merkle root
553         merkleRoot = _merkleRoot;
554         // update rate
555         rate = _rate;
556 
557         emit NewRound(merkleRoot,rate);
558     }
559 
560     /// @notice         mint amount to target
561     /// @param target   address to which to mint; if address(0), will burn
562     /// @param amount   to reduce from max supply or mint to "target"
563     function manage(
564         address target,
565         uint256 amount
566     ) external onlyConcave {
567         uint256 newAmount = totalMinted + amount;
568         require(newAmount <= maxSupply,EXCEEDS_SUPPLY);
569         totalMinted = newAmount;
570         // mint target amount
571         _mint(target, amount);
572         emit Managed(target, amount, totalMinted);
573     }
574 
575     /// @notice             manage max supply
576     /// @param _maxSupply   new max supply
577     function manageSupply(uint256 _maxSupply) external onlyConcave {
578         require(_maxSupply >= totalMinted, "LOWER_THAN_MINT");
579         emit SupplyChanged(maxSupply, _maxSupply);
580         maxSupply = _maxSupply;
581     }
582 
583     /// @notice         Allows Concave to pause transfers in the event of a bug
584     /// @param paused   if transfers should be paused or not
585     function setTransfersPaused(bool paused) external onlyConcave {
586         transfersPaused = paused;
587     }
588 
589     /* ---------------------------------------------------------------------- */
590     /*                              PUBLIC LOGIC                              */
591     /* ---------------------------------------------------------------------- */
592 
593     /// @notice               mint pCNV by providing merkle proof and depositing DAI/FRAX
594     /// @param to             whitelisted address pCNV will be minted to
595     /// @param tokenIn        address of tokenIn user wishes to deposit (DAI/FRAX)
596     /// @param maxAmount      max amount of DAI/FRAX sender can deposit for pCNV, to verify merkle proof
597     /// @param amountIn       amount of DAI/FRAX sender wishes to deposit for pCNV
598     /// @param proof          merkle proof to prove "to" and "maxAmount" are in merkle tree
599     function mint(
600         address to,
601         address tokenIn,
602         uint256 maxAmount,
603         uint256 amountIn,
604         bytes32[] calldata proof
605     ) external returns (uint256 amountOut) {
606         return _purchase(msg.sender, to, tokenIn, maxAmount, amountIn, proof);
607     }
608 
609     /// @notice               mint pCNV by providing merkle proof and depositing DAI; uses EIP-2612 permit to save a transaction
610     /// @param to             whitelisted address pCNV will be minted to
611     /// @param tokenIn        address of tokenIn user wishes to deposit (DAI)
612     /// @param maxAmount      max amount of DAI sender can deposit for pCNV, to verify merkle proof
613     /// @param amountIn       amount of DAI sender wishes to deposit for pCNV
614     /// @param proof          merkle proof to prove "to" and "maxAmount" are in merkle tree
615     /// @param permitDeadline EIP-2612 : time when permit is no longer valid
616     /// @param v              EIP-2612 : part of EIP-2612 signature
617     /// @param r              EIP-2612 : part of EIP-2612 signature
618     /// @param s              EIP-2612 : part of EIP-2612 signature
619     function mintWithPermit(
620         address to,
621         address tokenIn,
622         uint256 maxAmount,
623         uint256 amountIn,
624         bytes32[] calldata proof,
625         uint256 permitDeadline,
626         uint8 v,
627         bytes32 r,
628         bytes32 s
629     ) external returns (uint256 amountOut) {
630         // Make sure payment tokenIn is DAI
631         require(tokenIn == address(DAI), TOKEN_IN_ERROR);
632         // Approve tokens for spender - https://eips.ethereum.org/EIPS/eip-2612
633         ERC20(tokenIn).permit(msg.sender, address(this), amountIn, permitDeadline, v, r, s);
634         // allow sender to mint for "to"
635         return _purchase(msg.sender, to, tokenIn, maxAmount, amountIn, proof);
636     }
637 
638     /// @notice         transfer "amount" of tokens from msg.sender to "to"
639     /// @dev            calls "_beforeTransfer" to update vesting storage for "from" and "to"
640     /// @param to       address tokens are being sent to
641     /// @param amount   number of tokens being transfered
642     function transfer(
643         address to,
644         uint256 amount
645     ) public virtual override returns (bool) {
646         require(!transfersPaused,PAUSED);
647         // default ERC20 transfer
648         return super.transfer(to, amount);
649     }
650 
651     /// @notice         transfer "amount" of tokens from "from" to "to"
652     /// @dev            calls "_beforeTransfer" to update vesting storage for "from" and "to"
653     /// @param from     address tokens are being transfered from
654     /// @param to       address tokens are being sent to
655     /// @param amount   number of tokens being transfered
656     function transferFrom(
657         address from,
658         address to,
659         uint256 amount
660     ) public virtual override returns (bool) {
661         require(!transfersPaused,PAUSED);
662         // default ERC20 transfer
663         return super.transferFrom(from, to, amount);
664     }
665 
666     /* ---------------------------------------------------------------------- */
667     /*                             INTERNAL LOGIC                             */
668     /* ---------------------------------------------------------------------- */
669 
670     /// @notice               Deposits FRAX/DAI for pCNV if merkle proof exists in specified round
671     /// @param sender         address sending transaction
672     /// @param to             whitelisted address purchased pCNV will be sent to
673     /// @param tokenIn        address of tokenIn user wishes to deposit
674     /// @param maxAmount      max amount of DAI/FRAX sender can deposit for pCNV
675     /// @param amountIn       amount of DAI/FRAX sender wishes to deposit for pCNV
676     /// @param proof          merkle proof to prove address and amount are in tree
677     function _purchase(
678         address sender,
679         address to,
680         address tokenIn,
681         uint256 maxAmount,
682         uint256 amountIn,
683         bytes32[] calldata proof
684     ) internal returns(uint256 amountOut) {
685         // Make sure payment tokenIn is either DAI or FRAX
686         require(tokenIn == address(DAI) || tokenIn == address(FRAX), TOKEN_IN_ERROR);
687 
688         // Require merkle proof with `to` and `maxAmount` to be successfully verified
689         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(to, maxAmount))), "!PROOF");
690 
691         // Verify amount claimed by user does not surpass "maxAmount"
692         uint256 newAmount = spentAmounts[merkleRoot][to] + amountIn; // save gas
693         require(newAmount <= maxAmount, AMOUNT_ERROR);
694         spentAmounts[merkleRoot][to] = newAmount;
695 
696         // Calculate rate of pCNV that should be returned for "amountIn"
697         amountOut = amountIn * 1e18 / rate;
698 
699         // make sure total minted + amount is less than or equal to maximum supply
700         require(totalMinted + amountOut <= maxSupply, EXCEEDS_SUPPLY);
701 
702         // Interface storage for participant
703         Participant storage participant = participants[to];
704 
705         // Increase participant.purchased to account for newly purchased tokens
706         participant.purchased += amountOut;
707 
708         // Increase totalMinted to account for newly minted supply
709         totalMinted += amountOut;
710 
711         // Transfer amountIn*ratio of tokenIn to treasury address
712         ERC20(tokenIn).safeTransferFrom(sender, treasury, amountIn);
713 
714         // Mint tokens to address after pulling
715         _mint(to, amountOut);
716 
717         emit Minted(sender, to, amountOut, amountIn, totalMinted);
718     }
719 
720     /// @notice         Rescues accidentally sent tokens and ETH
721     /// @param token    address of token to rescue, if address(0) rescue ETH
722     function rescue(address token) external onlyConcave {
723         if (token == address(0)) payable(treasury).transfer( address(this).balance );
724         else ERC20(token).transfer(treasury, ERC20(token).balanceOf(address(this)));
725     }
726 }
727 
728 /**
729 
730     "someone spent a lot of computational power and time to bruteforce that contract address
731     so basically to have that many leading zeros
732     you can't just create a contract and get that, the odds are 1 in trillions to get something like that
733     there's a way to guess which contract address you will get, using a script.. and you have to bruteforce for a very long time to get that many leading 0's
734     fun fact, the more leading 0's a contract has, the cheaper gas will be for users to interact with the contract"
735 
736         - some solidity dev
737 
738     © 2022 WTFPL – Do What the Fuck You Want to Public License.
739 */