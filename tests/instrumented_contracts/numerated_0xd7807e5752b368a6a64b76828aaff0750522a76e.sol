1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-27
3 */
4 
5 // Sources flattened with hardhat v2.9.2 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 
35 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
39 
40 
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 
113 // File @rari-capital/solmate/src/utils/ReentrancyGuard.sol@v6.2.0
114 
115 
116 pragma solidity >=0.8.0;
117 
118 /// @notice Gas optimized reentrancy protection for smart contracts.
119 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
120 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
121 abstract contract ReentrancyGuard {
122     uint256 private reentrancyStatus = 1;
123 
124     modifier nonReentrant() {
125         require(reentrancyStatus == 1, "REENTRANCY");
126 
127         reentrancyStatus = 2;
128 
129         _;
130 
131         reentrancyStatus = 1;
132     }
133 }
134 
135 
136 // File @rari-capital/solmate/src/tokens/ERC20.sol@v6.2.0
137 
138 
139 pragma solidity >=0.8.0;
140 
141 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
142 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
143 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
144 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
145 abstract contract ERC20 {
146     /*///////////////////////////////////////////////////////////////
147                                   EVENTS
148     //////////////////////////////////////////////////////////////*/
149 
150     event Transfer(address indexed from, address indexed to, uint256 amount);
151 
152     event Approval(address indexed owner, address indexed spender, uint256 amount);
153 
154     /*///////////////////////////////////////////////////////////////
155                              METADATA STORAGE
156     //////////////////////////////////////////////////////////////*/
157 
158     string public name;
159 
160     string public symbol;
161 
162     uint8 public immutable decimals;
163 
164     /*///////////////////////////////////////////////////////////////
165                               ERC20 STORAGE
166     //////////////////////////////////////////////////////////////*/
167 
168     uint256 public totalSupply;
169 
170     mapping(address => uint256) public balanceOf;
171 
172     mapping(address => mapping(address => uint256)) public allowance;
173 
174     /*///////////////////////////////////////////////////////////////
175                              EIP-2612 STORAGE
176     //////////////////////////////////////////////////////////////*/
177 
178     bytes32 public constant PERMIT_TYPEHASH =
179         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
180 
181     uint256 internal immutable INITIAL_CHAIN_ID;
182 
183     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
184 
185     mapping(address => uint256) public nonces;
186 
187     /*///////////////////////////////////////////////////////////////
188                                CONSTRUCTOR
189     //////////////////////////////////////////////////////////////*/
190 
191     constructor(
192         string memory _name,
193         string memory _symbol,
194         uint8 _decimals
195     ) {
196         name = _name;
197         symbol = _symbol;
198         decimals = _decimals;
199 
200         INITIAL_CHAIN_ID = block.chainid;
201         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
202     }
203 
204     /*///////////////////////////////////////////////////////////////
205                               ERC20 LOGIC
206     //////////////////////////////////////////////////////////////*/
207 
208     function approve(address spender, uint256 amount) public virtual returns (bool) {
209         allowance[msg.sender][spender] = amount;
210 
211         emit Approval(msg.sender, spender, amount);
212 
213         return true;
214     }
215 
216     function transfer(address to, uint256 amount) public virtual returns (bool) {
217         balanceOf[msg.sender] -= amount;
218 
219         // Cannot overflow because the sum of all user
220         // balances can't exceed the max uint256 value.
221         unchecked {
222             balanceOf[to] += amount;
223         }
224 
225         emit Transfer(msg.sender, to, amount);
226 
227         return true;
228     }
229 
230     function transferFrom(
231         address from,
232         address to,
233         uint256 amount
234     ) public virtual returns (bool) {
235         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
236 
237         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
238 
239         balanceOf[from] -= amount;
240 
241         // Cannot overflow because the sum of all user
242         // balances can't exceed the max uint256 value.
243         unchecked {
244             balanceOf[to] += amount;
245         }
246 
247         emit Transfer(from, to, amount);
248 
249         return true;
250     }
251 
252     /*///////////////////////////////////////////////////////////////
253                               EIP-2612 LOGIC
254     //////////////////////////////////////////////////////////////*/
255 
256     function permit(
257         address owner,
258         address spender,
259         uint256 value,
260         uint256 deadline,
261         uint8 v,
262         bytes32 r,
263         bytes32 s
264     ) public virtual {
265         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
266 
267         // Unchecked because the only math done is incrementing
268         // the owner's nonce which cannot realistically overflow.
269         unchecked {
270             bytes32 digest = keccak256(
271                 abi.encodePacked(
272                     "\x19\x01",
273                     DOMAIN_SEPARATOR(),
274                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
275                 )
276             );
277 
278             address recoveredAddress = ecrecover(digest, v, r, s);
279 
280             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
281 
282             allowance[recoveredAddress][spender] = value;
283         }
284 
285         emit Approval(owner, spender, value);
286     }
287 
288     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
289         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
290     }
291 
292     function computeDomainSeparator() internal view virtual returns (bytes32) {
293         return
294             keccak256(
295                 abi.encode(
296                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
297                     keccak256(bytes(name)),
298                     keccak256("1"),
299                     block.chainid,
300                     address(this)
301                 )
302             );
303     }
304 
305     /*///////////////////////////////////////////////////////////////
306                        INTERNAL MINT/BURN LOGIC
307     //////////////////////////////////////////////////////////////*/
308 
309     function _mint(address to, uint256 amount) internal virtual {
310         totalSupply += amount;
311 
312         // Cannot overflow because the sum of all user
313         // balances can't exceed the max uint256 value.
314         unchecked {
315             balanceOf[to] += amount;
316         }
317 
318         emit Transfer(address(0), to, amount);
319     }
320 
321     function _burn(address from, uint256 amount) internal virtual {
322         balanceOf[from] -= amount;
323 
324         // Cannot underflow because a user's balance
325         // will never be larger than the total supply.
326         unchecked {
327             totalSupply -= amount;
328         }
329 
330         emit Transfer(from, address(0), amount);
331     }
332 }
333 
334 
335 // File @rari-capital/solmate/src/utils/SafeTransferLib.sol@v6.2.0
336 
337 
338 pragma solidity >=0.8.0;
339 
340 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
341 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
342 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
343 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
344 library SafeTransferLib {
345     /*///////////////////////////////////////////////////////////////
346                             ETH OPERATIONS
347     //////////////////////////////////////////////////////////////*/
348 
349     function safeTransferETH(address to, uint256 amount) internal {
350         bool callStatus;
351 
352         assembly {
353             // Transfer the ETH and store if it succeeded or not.
354             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
355         }
356 
357         require(callStatus, "ETH_TRANSFER_FAILED");
358     }
359 
360     /*///////////////////////////////////////////////////////////////
361                            ERC20 OPERATIONS
362     //////////////////////////////////////////////////////////////*/
363 
364     function safeTransferFrom(
365         ERC20 token,
366         address from,
367         address to,
368         uint256 amount
369     ) internal {
370         bool callStatus;
371 
372         assembly {
373             // Get a pointer to some free memory.
374             let freeMemoryPointer := mload(0x40)
375 
376             // Write the abi-encoded calldata to memory piece by piece:
377             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
378             mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "from" argument.
379             mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
380             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
381 
382             // Call the token and store if it succeeded or not.
383             // We use 100 because the calldata length is 4 + 32 * 3.
384             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
385         }
386 
387         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FROM_FAILED");
388     }
389 
390     function safeTransfer(
391         ERC20 token,
392         address to,
393         uint256 amount
394     ) internal {
395         bool callStatus;
396 
397         assembly {
398             // Get a pointer to some free memory.
399             let freeMemoryPointer := mload(0x40)
400 
401             // Write the abi-encoded calldata to memory piece by piece:
402             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
403             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
404             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
405 
406             // Call the token and store if it succeeded or not.
407             // We use 68 because the calldata length is 4 + 32 * 2.
408             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
409         }
410 
411         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FAILED");
412     }
413 
414     function safeApprove(
415         ERC20 token,
416         address to,
417         uint256 amount
418     ) internal {
419         bool callStatus;
420 
421         assembly {
422             // Get a pointer to some free memory.
423             let freeMemoryPointer := mload(0x40)
424 
425             // Write the abi-encoded calldata to memory piece by piece:
426             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
427             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
428             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
429 
430             // Call the token and store if it succeeded or not.
431             // We use 68 because the calldata length is 4 + 32 * 2.
432             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
433         }
434 
435         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
436     }
437 
438     /*///////////////////////////////////////////////////////////////
439                          INTERNAL HELPER LOGIC
440     //////////////////////////////////////////////////////////////*/
441 
442     function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool success) {
443         assembly {
444             // Get how many bytes the call returned.
445             let returnDataSize := returndatasize()
446 
447             // If the call reverted:
448             if iszero(callStatus) {
449                 // Copy the revert message into memory.
450                 returndatacopy(0, 0, returnDataSize)
451 
452                 // Revert with the same message.
453                 revert(0, returnDataSize)
454             }
455 
456             switch returnDataSize
457             case 32 {
458                 // Copy the return data into memory.
459                 returndatacopy(0, 0, returnDataSize)
460 
461                 // Set success to whether it returned true.
462                 success := iszero(iszero(mload(0)))
463             }
464             case 0 {
465                 // There was no return data.
466                 success := 1
467             }
468             default {
469                 // It returned some malformed input.
470                 success := 0
471             }
472         }
473     }
474 }
475 
476 
477 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
478 
479 
480 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
481 
482 
483 
484 /**
485  * @dev These functions deal with verification of Merkle Trees proofs.
486  *
487  * The proofs can be generated using the JavaScript library
488  * https://github.com/miguelmota/merkletreejs[merkletreejs].
489  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
490  *
491  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
492  */
493 library MerkleProof {
494     /**
495      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
496      * defined by `root`. For this, a `proof` must be provided, containing
497      * sibling hashes on the branch from the leaf to the root of the tree. Each
498      * pair of leaves and each pair of pre-images are assumed to be sorted.
499      */
500     function verify(
501         bytes32[] memory proof,
502         bytes32 root,
503         bytes32 leaf
504     ) internal pure returns (bool) {
505         return processProof(proof, leaf) == root;
506     }
507 
508     /**
509      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
510      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
511      * hash matches the root of the tree. When processing the proof, the pairs
512      * of leafs & pre-images are assumed to be sorted.
513      *
514      * _Available since v4.4._
515      */
516     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
517         bytes32 computedHash = leaf;
518         for (uint256 i = 0; i < proof.length; i++) {
519             bytes32 proofElement = proof[i];
520             if (computedHash <= proofElement) {
521                 // Hash(current computed hash + current element of the proof)
522                 computedHash = _efficientHash(computedHash, proofElement);
523             } else {
524                 // Hash(current element of the proof + current computed hash)
525                 computedHash = _efficientHash(proofElement, computedHash);
526             }
527         }
528         return computedHash;
529     }
530 
531     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
532         assembly {
533             mstore(0x00, a)
534             mstore(0x20, b)
535             value := keccak256(0x00, 0x40)
536         }
537     }
538 }
539 
540 
541 // File contracts/core/RewardDistributor.sol
542 
543 // SPDX-License-Identifier: MIT
544 pragma solidity 0.8.12;
545 
546 
547 
548 
549 
550 /// @title RewardDistributor
551 /// @author ████
552 
553 /**
554     @notice
555     Adapted from Hidden-Hand's RewardDistributor
556 */
557 
558 contract RewardDistributor is Ownable, ReentrancyGuard {
559     using SafeTransferLib for ERC20;
560 
561     struct Distribution {
562         address token;
563         bytes32 merkleRoot;
564         bytes32 proof;
565     }
566 
567     struct Reward {
568         address token;
569         bytes32 merkleRoot;
570         bytes32 proof;
571         uint256 updateCount;
572     }
573 
574     struct Claim {
575         address token;
576         address account;
577         uint256 amount;
578         bytes32[] merkleProof;
579     }
580 
581     // Address of the Multisig (also as the primary source of rewards)
582     address public immutable MULTISIG;
583 
584     // Maps each of the token address to its reward metadata
585     mapping(address => Reward) public rewards;
586     // Tracks the amount of claimed reward for the specified token address + account
587     mapping(address => mapping(address => uint256)) public claimed;
588 
589     event RewardClaimed(
590         address indexed token,
591         address indexed account,
592         uint256 amount,
593         uint256 updateCount
594     );
595 
596     event RewardMetadataUpdated(
597         address indexed token,
598         bytes32 merkleRoot,
599         bytes32 proof,
600         uint256 indexed updateCount
601     );
602 
603     constructor(address multisig) {
604         require(multisig != address(0), "Invalid address");
605         MULTISIG = multisig;
606     }
607 
608     /**
609         @notice Enables and restricts native token ingress to Multisig
610      */
611     receive() external payable {
612         if (msg.sender != MULTISIG) revert("Not MULTISIG");
613     }
614 
615     /**
616         @notice Claim rewards based on the specified metadata
617         @param  claims  Claim[] List of claim metadata
618      */
619     function claim(Claim[] calldata claims) external nonReentrant {
620         require(claims.length != 0, "Invalid claims");
621 
622         for (uint256 i; i < claims.length; ++i) {
623             _claim(
624                 claims[i].token,
625                 claims[i].account,
626                 claims[i].amount,
627                 claims[i].merkleProof
628             );
629         }
630     }
631 
632     /**
633         @notice Update rewards metadata
634         @param  distributions  Distribution[] List of reward distribution details
635      */
636     function updateRewardsMetadata(Distribution[] calldata distributions)
637         external
638         onlyOwner
639     {
640         require(distributions.length != 0, "Invalid distributions");
641 
642         for (uint256 i; i < distributions.length; ++i) {
643             // Update the metadata and also increment the update counter
644             Distribution calldata distribution = distributions[i];
645             Reward storage reward = rewards[distribution.token];
646             reward.token = distribution.token;
647             reward.merkleRoot = distribution.merkleRoot;
648             reward.proof = distribution.proof;
649             ++reward.updateCount;
650 
651             emit RewardMetadataUpdated(
652                 distribution.token,
653                 distribution.merkleRoot,
654                 distribution.proof,
655                 reward.updateCount
656             );
657         }
658     }
659 
660     /**
661         @notice Claim a reward
662         @param  token        address    Token address
663         @param  account      address    Eligible user account
664         @param  amount       uint256    Reward amount
665         @param  merkleProof  bytes32[]  Merkle proof
666      */
667     function _claim(
668         address token,
669         address account,
670         uint256 amount,
671         bytes32[] calldata merkleProof
672     ) private {
673         Reward memory reward = rewards[token];
674 
675         require(reward.merkleRoot != 0, "Distribution not enabled");
676 
677         // Verify the merkle proof
678         require(
679             MerkleProof.verify(
680                 merkleProof,
681                 reward.merkleRoot,
682                 keccak256(abi.encodePacked(account, amount))
683             ),
684             "Invalid proof"
685         );
686 
687         // Verify the claimable amount
688         require(claimed[token][account] < amount, "No claimable reward");
689 
690         // Calculate the claimable amount based off the total of reward (used in the merkle tree)
691         // since the beginning for the user, minus the total claimed so far
692         uint256 claimable = amount - claimed[token][account];
693         // Update the claimed amount to the current total
694         claimed[token][account] = amount;
695 
696         // Check whether the reward is in the form of native tokens or ERC20
697         // by checking if the token address is set to the Multisig or not
698         if (token != MULTISIG) {
699             ERC20(token).safeTransfer(account, claimable);
700         } else {
701             (bool sent, ) = payable(account).call{value: claimable}("");
702             require(sent, "Failed to transfer to account");
703         }
704 
705         emit RewardClaimed(
706             token,
707             account,
708             claimable,
709             reward.updateCount
710         );
711     }
712 }