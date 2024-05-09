1 // Sources flattened with hardhat v2.9.2 https://hardhat.org
2 
3 // File @rari-capital/solmate/src/utils/ReentrancyGuard.sol@v6.2.0
4 
5 
6 
7 
8 /// @notice Gas optimized reentrancy protection for smart contracts.
9 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
10 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
11 abstract contract ReentrancyGuard {
12     uint256 private reentrancyStatus = 1;
13 
14     modifier nonReentrant() {
15         require(reentrancyStatus == 1, "REENTRANCY");
16 
17         reentrancyStatus = 2;
18 
19         _;
20 
21         reentrancyStatus = 1;
22     }
23 }
24 
25 
26 // File @rari-capital/solmate/src/tokens/ERC20.sol@v6.2.0
27 
28 
29 
30 
31 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
32 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
33 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
34 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
35 abstract contract ERC20 {
36     /*///////////////////////////////////////////////////////////////
37                                   EVENTS
38     //////////////////////////////////////////////////////////////*/
39 
40     event Transfer(address indexed from, address indexed to, uint256 amount);
41 
42     event Approval(address indexed owner, address indexed spender, uint256 amount);
43 
44     /*///////////////////////////////////////////////////////////////
45                              METADATA STORAGE
46     //////////////////////////////////////////////////////////////*/
47 
48     string public name;
49 
50     string public symbol;
51 
52     uint8 public immutable decimals;
53 
54     /*///////////////////////////////////////////////////////////////
55                               ERC20 STORAGE
56     //////////////////////////////////////////////////////////////*/
57 
58     uint256 public totalSupply;
59 
60     mapping(address => uint256) public balanceOf;
61 
62     mapping(address => mapping(address => uint256)) public allowance;
63 
64     /*///////////////////////////////////////////////////////////////
65                              EIP-2612 STORAGE
66     //////////////////////////////////////////////////////////////*/
67 
68     bytes32 public constant PERMIT_TYPEHASH =
69         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
70 
71     uint256 internal immutable INITIAL_CHAIN_ID;
72 
73     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
74 
75     mapping(address => uint256) public nonces;
76 
77     /*///////////////////////////////////////////////////////////////
78                                CONSTRUCTOR
79     //////////////////////////////////////////////////////////////*/
80 
81     constructor(
82         string memory _name,
83         string memory _symbol,
84         uint8 _decimals
85     ) {
86         name = _name;
87         symbol = _symbol;
88         decimals = _decimals;
89 
90         INITIAL_CHAIN_ID = block.chainid;
91         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
92     }
93 
94     /*///////////////////////////////////////////////////////////////
95                               ERC20 LOGIC
96     //////////////////////////////////////////////////////////////*/
97 
98     function approve(address spender, uint256 amount) public virtual returns (bool) {
99         allowance[msg.sender][spender] = amount;
100 
101         emit Approval(msg.sender, spender, amount);
102 
103         return true;
104     }
105 
106     function transfer(address to, uint256 amount) public virtual returns (bool) {
107         balanceOf[msg.sender] -= amount;
108 
109         // Cannot overflow because the sum of all user
110         // balances can't exceed the max uint256 value.
111         unchecked {
112             balanceOf[to] += amount;
113         }
114 
115         emit Transfer(msg.sender, to, amount);
116 
117         return true;
118     }
119 
120     function transferFrom(
121         address from,
122         address to,
123         uint256 amount
124     ) public virtual returns (bool) {
125         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
126 
127         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
128 
129         balanceOf[from] -= amount;
130 
131         // Cannot overflow because the sum of all user
132         // balances can't exceed the max uint256 value.
133         unchecked {
134             balanceOf[to] += amount;
135         }
136 
137         emit Transfer(from, to, amount);
138 
139         return true;
140     }
141 
142     /*///////////////////////////////////////////////////////////////
143                               EIP-2612 LOGIC
144     //////////////////////////////////////////////////////////////*/
145 
146     function permit(
147         address owner,
148         address spender,
149         uint256 value,
150         uint256 deadline,
151         uint8 v,
152         bytes32 r,
153         bytes32 s
154     ) public virtual {
155         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
156 
157         // Unchecked because the only math done is incrementing
158         // the owner's nonce which cannot realistically overflow.
159         unchecked {
160             bytes32 digest = keccak256(
161                 abi.encodePacked(
162                     "\x19\x01",
163                     DOMAIN_SEPARATOR(),
164                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
165                 )
166             );
167 
168             address recoveredAddress = ecrecover(digest, v, r, s);
169 
170             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
171 
172             allowance[recoveredAddress][spender] = value;
173         }
174 
175         emit Approval(owner, spender, value);
176     }
177 
178     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
179         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
180     }
181 
182     function computeDomainSeparator() internal view virtual returns (bytes32) {
183         return
184             keccak256(
185                 abi.encode(
186                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
187                     keccak256(bytes(name)),
188                     keccak256("1"),
189                     block.chainid,
190                     address(this)
191                 )
192             );
193     }
194 
195     /*///////////////////////////////////////////////////////////////
196                        INTERNAL MINT/BURN LOGIC
197     //////////////////////////////////////////////////////////////*/
198 
199     function _mint(address to, uint256 amount) internal virtual {
200         totalSupply += amount;
201 
202         // Cannot overflow because the sum of all user
203         // balances can't exceed the max uint256 value.
204         unchecked {
205             balanceOf[to] += amount;
206         }
207 
208         emit Transfer(address(0), to, amount);
209     }
210 
211     function _burn(address from, uint256 amount) internal virtual {
212         balanceOf[from] -= amount;
213 
214         // Cannot underflow because a user's balance
215         // will never be larger than the total supply.
216         unchecked {
217             totalSupply -= amount;
218         }
219 
220         emit Transfer(from, address(0), amount);
221     }
222 }
223 
224 
225 // File @rari-capital/solmate/src/utils/SafeTransferLib.sol@v6.2.0
226 
227 
228 
229 
230 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
231 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
232 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
233 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
234 library SafeTransferLib {
235     /*///////////////////////////////////////////////////////////////
236                             ETH OPERATIONS
237     //////////////////////////////////////////////////////////////*/
238 
239     function safeTransferETH(address to, uint256 amount) internal {
240         bool callStatus;
241 
242         assembly {
243             // Transfer the ETH and store if it succeeded or not.
244             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
245         }
246 
247         require(callStatus, "ETH_TRANSFER_FAILED");
248     }
249 
250     /*///////////////////////////////////////////////////////////////
251                            ERC20 OPERATIONS
252     //////////////////////////////////////////////////////////////*/
253 
254     function safeTransferFrom(
255         ERC20 token,
256         address from,
257         address to,
258         uint256 amount
259     ) internal {
260         bool callStatus;
261 
262         assembly {
263             // Get a pointer to some free memory.
264             let freeMemoryPointer := mload(0x40)
265 
266             // Write the abi-encoded calldata to memory piece by piece:
267             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
268             mstore(add(freeMemoryPointer, 4), and(from, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "from" argument.
269             mstore(add(freeMemoryPointer, 36), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
270             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
271 
272             // Call the token and store if it succeeded or not.
273             // We use 100 because the calldata length is 4 + 32 * 3.
274             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
275         }
276 
277         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FROM_FAILED");
278     }
279 
280     function safeTransfer(
281         ERC20 token,
282         address to,
283         uint256 amount
284     ) internal {
285         bool callStatus;
286 
287         assembly {
288             // Get a pointer to some free memory.
289             let freeMemoryPointer := mload(0x40)
290 
291             // Write the abi-encoded calldata to memory piece by piece:
292             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
293             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
294             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
295 
296             // Call the token and store if it succeeded or not.
297             // We use 68 because the calldata length is 4 + 32 * 2.
298             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
299         }
300 
301         require(didLastOptionalReturnCallSucceed(callStatus), "TRANSFER_FAILED");
302     }
303 
304     function safeApprove(
305         ERC20 token,
306         address to,
307         uint256 amount
308     ) internal {
309         bool callStatus;
310 
311         assembly {
312             // Get a pointer to some free memory.
313             let freeMemoryPointer := mload(0x40)
314 
315             // Write the abi-encoded calldata to memory piece by piece:
316             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000) // Begin with the function selector.
317             mstore(add(freeMemoryPointer, 4), and(to, 0xffffffffffffffffffffffffffffffffffffffff)) // Mask and append the "to" argument.
318             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
319 
320             // Call the token and store if it succeeded or not.
321             // We use 68 because the calldata length is 4 + 32 * 2.
322             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
323         }
324 
325         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
326     }
327 
328     /*///////////////////////////////////////////////////////////////
329                          INTERNAL HELPER LOGIC
330     //////////////////////////////////////////////////////////////*/
331 
332     function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool success) {
333         assembly {
334             // Get how many bytes the call returned.
335             let returnDataSize := returndatasize()
336 
337             // If the call reverted:
338             if iszero(callStatus) {
339                 // Copy the revert message into memory.
340                 returndatacopy(0, 0, returnDataSize)
341 
342                 // Revert with the same message.
343                 revert(0, returnDataSize)
344             }
345 
346             switch returnDataSize
347             case 32 {
348                 // Copy the return data into memory.
349                 returndatacopy(0, 0, returnDataSize)
350 
351                 // Set success to whether it returned true.
352                 success := iszero(iszero(mload(0)))
353             }
354             case 0 {
355                 // There was no return data.
356                 success := 1
357             }
358             default {
359                 // It returned some malformed input.
360                 success := 0
361             }
362         }
363     }
364 }
365 
366 
367 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
370 
371 
372 /**
373  * @dev Provides information about the current execution context, including the
374  * sender of the transaction and its data. While these are generally available
375  * via msg.sender and msg.data, they should not be accessed in such a direct
376  * manner, since when dealing with meta-transactions the account sending and
377  * paying for execution may not be the actual sender (as far as an application
378  * is concerned).
379  *
380  * This contract is only required for intermediate, library-like contracts.
381  */
382 abstract contract Context {
383     function _msgSender() internal view virtual returns (address) {
384         return msg.sender;
385     }
386 
387     function _msgData() internal view virtual returns (bytes calldata) {
388         return msg.data;
389     }
390 }
391 
392 
393 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
394 
395 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
396 
397 
398 /**
399  * @dev Contract module which provides a basic access control mechanism, where
400  * there is an account (an owner) that can be granted exclusive access to
401  * specific functions.
402  *
403  * By default, the owner account will be the one that deploys the contract. This
404  * can later be changed with {transferOwnership}.
405  *
406  * This module is used through inheritance. It will make available the modifier
407  * `onlyOwner`, which can be applied to your functions to restrict their use to
408  * the owner.
409  */
410 abstract contract Ownable is Context {
411     address private _owner;
412 
413     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
414 
415     /**
416      * @dev Initializes the contract setting the deployer as the initial owner.
417      */
418     constructor() {
419         _transferOwnership(_msgSender());
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view virtual returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(owner() == _msgSender(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437     /**
438      * @dev Leaves the contract without owner. It will not be possible to call
439      * `onlyOwner` functions anymore. Can only be called by the current owner.
440      *
441      * NOTE: Renouncing ownership will leave the contract without an owner,
442      * thereby removing any functionality that is only available to the owner.
443      */
444     function renounceOwnership() public virtual onlyOwner {
445         _transferOwnership(address(0));
446     }
447 
448     /**
449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
450      * Can only be called by the current owner.
451      */
452     function transferOwnership(address newOwner) public virtual onlyOwner {
453         require(newOwner != address(0), "Ownable: new owner is the zero address");
454         _transferOwnership(newOwner);
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Internal function without access restriction.
460      */
461     function _transferOwnership(address newOwner) internal virtual {
462         address oldOwner = _owner;
463         _owner = newOwner;
464         emit OwnershipTransferred(oldOwner, newOwner);
465     }
466 }
467 
468 
469 // File contracts/core/RLBTRFLY.sol
470 
471 // SPDX-License-Identifier: MIT
472 pragma solidity 0.8.12;
473 
474 
475 
476 
477 /// @title RLBTRFLY
478 /// @author ████
479 
480 /**
481     @notice
482     Partially adapted from Convex's CvxLockerV2 contract with some modifications and optimizations for the BTRFLY V2 requirements
483 */
484 
485 contract RLBTRFLY is ReentrancyGuard, Ownable {
486     using SafeTransferLib for ERC20;
487 
488     /**
489         @notice Lock balance details
490         @param  amount      uint224  Locked amount in the lock
491         @param  unlockTime  uint32   Unlock time of the lock
492      */
493     struct LockedBalance {
494         uint224 amount;
495         uint32 unlockTime;
496     }
497 
498     /**
499         @notice Balance details
500         @param  locked           uint224          Overall locked amount
501         @param  nextUnlockIndex  uint32           Index of earliest next unlock
502         @param  lockedBalances   LockedBalance[]  List of locked balances data
503      */
504     struct Balance {
505         uint224 locked;
506         uint32 nextUnlockIndex;
507         LockedBalance[] lockedBalances;
508     }
509 
510     // 1 epoch = 1 week
511     uint32 public constant EPOCH_DURATION = 1 weeks;
512     // Full lock duration = 16 epochs
513     uint256 public constant LOCK_DURATION = 16 * EPOCH_DURATION;
514 
515     ERC20 public immutable btrflyV2;
516 
517     uint256 public lockedSupply;
518 
519     mapping(address => Balance) public balances;
520 
521     bool public isShutdown;
522 
523     string public constant name = "Revenue-Locked BTRFLY";
524     string public constant symbol = "rlBTRFLY";
525     uint8 public constant decimals = 18;
526 
527     event Shutdown();
528     event Locked(
529         address indexed account,
530         uint256 indexed epoch,
531         uint256 amount
532     );
533     event Withdrawn(address indexed account, uint256 amount, bool relock);
534 
535     error ZeroAddress();
536     error ZeroAmount();
537     error IsShutdown();
538     error InvalidNumber(uint256 value);
539 
540     /**
541         @param  _btrflyV2  address  BTRFLYV2 token address
542      */
543     constructor(address _btrflyV2) {
544         if (_btrflyV2 == address(0)) revert ZeroAddress();
545         btrflyV2 = ERC20(_btrflyV2);
546     }
547 
548     /**
549         @notice Emergency method to shutdown the current locker contract which also force-unlock all locked tokens
550      */
551     function shutdown() external onlyOwner {
552         if (isShutdown) revert IsShutdown();
553 
554         isShutdown = true;
555 
556         emit Shutdown();
557     }
558 
559     /**
560         @notice Locked balance of the specified account including those with expired locks
561         @param  account  address  Account
562         @return amount   uint256  Amount
563      */
564     function lockedBalanceOf(address account)
565         external
566         view
567         returns (uint256 amount)
568     {
569         return balances[account].locked;
570     }
571 
572     /**
573         @notice Balance of the specified account by only including tokens in active locks
574         @param  account  address  Account
575         @return amount   uint256  Amount
576      */
577     function balanceOf(address account) external view returns (uint256 amount) {
578         // Using storage as it's actually cheaper than allocating a new memory based variable
579         Balance storage userBalance = balances[account];
580         LockedBalance[] storage locks = userBalance.lockedBalances;
581         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
582 
583         amount = balances[account].locked;
584 
585         uint256 locksLength = locks.length;
586 
587         // Skip all old records
588         for (uint256 i = nextUnlockIndex; i < locksLength; ++i) {
589             if (locks[i].unlockTime <= block.timestamp) {
590                 amount -= locks[i].amount;
591             } else {
592                 break;
593             }
594         }
595 
596         // Remove amount locked in the next epoch
597         if (
598             locksLength > 0 &&
599             uint256(locks[locksLength - 1].unlockTime) - LOCK_DURATION >
600             getCurrentEpoch()
601         ) {
602             amount -= locks[locksLength - 1].amount;
603         }
604 
605         return amount;
606     }
607 
608     /**
609         @notice Pending locked amount at the specified account
610         @param  account  address  Account
611         @return amount   uint256  Amount
612      */
613     function pendingLockOf(address account)
614         external
615         view
616         returns (uint256 amount)
617     {
618         LockedBalance[] storage locks = balances[account].lockedBalances;
619 
620         uint256 locksLength = locks.length;
621 
622         if (
623             locksLength > 0 &&
624             uint256(locks[locksLength - 1].unlockTime) - LOCK_DURATION >
625             getCurrentEpoch()
626         ) {
627             return locks[locksLength - 1].amount;
628         }
629 
630         return 0;
631     }
632 
633     /**
634         @notice Locked balances details for the specifed account
635         @param  account     address          Account
636         @return total       uint256          Total amount
637         @return unlockable  uint256          Unlockable amount
638         @return locked      uint256          Locked amount
639         @return lockData    LockedBalance[]  List of active locks
640      */
641     function lockedBalances(address account)
642         external
643         view
644         returns (
645             uint256 total,
646             uint256 unlockable,
647             uint256 locked,
648             LockedBalance[] memory lockData
649         )
650     {
651         Balance storage userBalance = balances[account];
652         LockedBalance[] storage locks = userBalance.lockedBalances;
653         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
654         uint256 idx;
655 
656         for (uint256 i = nextUnlockIndex; i < locks.length; ++i) {
657             if (locks[i].unlockTime > block.timestamp) {
658                 if (idx == 0) {
659                     lockData = new LockedBalance[](locks.length - i);
660                 }
661 
662                 lockData[idx] = locks[i];
663                 locked += lockData[idx].amount;
664                 ++idx;
665             } else {
666                 unlockable += locks[i].amount;
667             }
668         }
669 
670         return (userBalance.locked, unlockable, locked, lockData);
671     }
672 
673     /**
674         @notice Get current epoch
675         @return uint256  Current epoch
676      */
677     function getCurrentEpoch() public view returns (uint256) {
678         return (block.timestamp / EPOCH_DURATION) * EPOCH_DURATION;
679     }
680 
681     /**
682         @notice Locked tokens cannot be withdrawn for the entire lock duration and are eligible to receive rewards
683         @param  account  address  Account
684         @param  amount   uint256  Amount
685      */
686     function lock(address account, uint256 amount) external nonReentrant {
687         if (account == address(0)) revert ZeroAddress();
688         if (amount == 0) revert ZeroAmount();
689 
690         btrflyV2.safeTransferFrom(msg.sender, address(this), amount);
691 
692         _lock(account, amount);
693     }
694 
695     /**
696         @notice Perform the actual lock
697         @param  account  address  Account
698         @param  amount   uint256  Amount
699      */
700     function _lock(address account, uint256 amount) internal {
701         if (isShutdown) revert IsShutdown();
702 
703         Balance storage balance = balances[account];
704 
705         uint224 lockAmount = _toUint224(amount);
706 
707         balance.locked += lockAmount;
708         lockedSupply += lockAmount;
709 
710         uint256 lockEpoch = getCurrentEpoch() + EPOCH_DURATION;
711         uint256 unlockTime = lockEpoch + LOCK_DURATION;
712         LockedBalance[] storage locks = balance.lockedBalances;
713         uint256 idx = locks.length;
714 
715         // If the latest user lock is smaller than this lock, add a new entry to the end of the list
716         // else, append it to the latest user lock
717         if (idx == 0 || locks[idx - 1].unlockTime < unlockTime) {
718             locks.push(
719                 LockedBalance({
720                     amount: lockAmount,
721                     unlockTime: _toUint32(unlockTime)
722                 })
723             );
724         } else {
725             locks[idx - 1].amount += lockAmount;
726         }
727 
728         emit Locked(account, lockEpoch, amount);
729     }
730 
731     /**
732         @notice Withdraw all currently locked tokens where the unlock time has passed
733         @param  account     address  Account
734         @param  relock      bool     Whether should relock
735         @param  withdrawTo  address  Target receiver
736      */
737     function _processExpiredLocks(
738         address account,
739         bool relock,
740         address withdrawTo
741     ) internal {
742         // Using storage as it's actually cheaper than allocating a new memory based variable
743         Balance storage userBalance = balances[account];
744         LockedBalance[] storage locks = userBalance.lockedBalances;
745         uint224 locked;
746         uint256 length = locks.length;
747 
748         if (isShutdown || locks[length - 1].unlockTime <= block.timestamp) {
749             locked = userBalance.locked;
750             userBalance.nextUnlockIndex = _toUint32(length);
751         } else {
752             // Using nextUnlockIndex to reduce the number of loops
753             uint32 nextUnlockIndex = userBalance.nextUnlockIndex;
754 
755             for (uint256 i = nextUnlockIndex; i < length; ++i) {
756                 // Unlock time must be less or equal to time
757                 if (locks[i].unlockTime > block.timestamp) break;
758 
759                 // Add to cumulative amounts
760                 locked += locks[i].amount;
761                 ++nextUnlockIndex;
762             }
763 
764             // Update the account's next unlock index
765             userBalance.nextUnlockIndex = nextUnlockIndex;
766         }
767 
768         if (locked == 0) revert ZeroAmount();
769 
770         // Update user balances and total supplies
771         userBalance.locked -= locked;
772         lockedSupply -= locked;
773 
774         emit Withdrawn(account, locked, relock);
775 
776         // Relock or return to user
777         if (relock) {
778             _lock(withdrawTo, locked);
779         } else {
780             btrflyV2.safeTransfer(withdrawTo, locked);
781         }
782     }
783 
784     /**
785         @notice Withdraw expired locks to a different address
786         @param  to  address  Target receiver
787      */
788     function withdrawExpiredLocksTo(address to) external nonReentrant {
789         if (to == address(0)) revert ZeroAddress();
790 
791         _processExpiredLocks(msg.sender, false, to);
792     }
793 
794     /**
795         @notice Withdraw/relock all currently locked tokens where the unlock time has passed
796         @param  relock  bool  Whether should relock
797      */
798     function processExpiredLocks(bool relock) external nonReentrant {
799         _processExpiredLocks(msg.sender, relock, msg.sender);
800     }
801 
802     /**
803         @notice Validate and cast a uint256 integer to uint224
804         @param  value  uint256  Value
805         @return        uint224  Casted value
806      */
807     function _toUint224(uint256 value) internal pure returns (uint224) {
808         if (value > type(uint224).max) revert InvalidNumber(value);
809 
810         return uint224(value);
811     }
812 
813     /**
814         @notice Validate and cast a uint256 integer to uint32
815         @param  value  uint256  Value
816         @return        uint32   Casted value
817      */
818     function _toUint32(uint256 value) internal pure returns (uint32) {
819         if (value > type(uint32).max) revert InvalidNumber(value);
820 
821         return uint32(value);
822     }
823 }