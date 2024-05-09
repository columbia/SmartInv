1 // File: contracts/token/GovernanceStorage.sol
2 
3 pragma solidity 0.5.16;
4 
5 
6 /* Copyright 2020 Compound Labs, Inc.
7 
8 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
9 
10 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
11 
12 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
13 
14 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
15 
16 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
17 
18 
19 contract GovernanceStorage {
20     /// @notice A record of each accounts delegate
21     mapping (address => address) internal _delegates;
22 
23     /// @notice A checkpoint for marking number of votes from a given block
24     struct Checkpoint {
25         uint32 fromBlock;
26         uint256 votes;
27     }
28 
29     /// @notice A record of votes checkpoints for each account, by index
30     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
31 
32     /// @notice The number of checkpoints for each account
33     mapping (address => uint32) public numCheckpoints;
34 }
35 
36 // File: @openzeppelin/contracts/math/SafeMath.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `+` operator.
59      *
60      * Requirements:
61      * - Addition cannot overflow.
62      */
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      * - Subtraction cannot overflow.
78      */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     /**
84      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
85      * overflow (when the result is negative).
86      *
87      * Counterpart to Solidity's `-` operator.
88      *
89      * Requirements:
90      * - Subtraction cannot overflow.
91      *
92      * _Available since v2.4.0._
93      */
94     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      * - Multiplication cannot overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
112         // benefit is lost if 'b' is also tested.
113         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
114         if (a == 0) {
115             return 0;
116         }
117 
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers. Reverts on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator. Note: this function uses a
129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
130      * uses an invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return div(a, b, "SafeMath: division by zero");
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         // Solidity only automatically asserts when dividing by 0
154         require(b > 0, errorMessage);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         return mod(a, b, "SafeMath: modulo by zero");
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts with custom message when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      *
187      * _Available since v2.4.0._
188      */
189     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b != 0, errorMessage);
191         return a % b;
192     }
193 }
194 
195 
196 // File: contracts/token/TokenStorage.sol
197 
198 // SPDX-License-Identifier: MIT
199 
200 pragma solidity 0.5.16;
201 
202 
203 contract TokenStorage {
204 
205   using SafeMath for uint256;
206 
207   /**
208    * @notice EIP-20 token name for this token
209    */
210   string public name;
211 
212   /**
213    * @notice EIP-20 token symbol for this token
214    */
215   string public symbol;
216 
217   /**
218    * @notice EIP-20 token decimals for this token
219    */
220   uint8 public decimals;
221 
222   /**
223    * @notice Governor for this contract
224    */
225   address public gov;
226 
227   /**
228    * @notice Pending governance for this contract
229    */
230   address public pendingGov;
231 
232   /**
233    * @notice Approved token emitter for this contract
234    */
235   address public emission;
236   
237   /**
238    * @notice Approved token guardian for this contract
239    */
240   address public guardian;
241   
242   /**
243    * @notice Total supply of LIFE
244    */
245   uint256 public totalSupply;
246 
247   /**
248    * @notice Used for pausing and unpausing
249    */
250   bool internal _paused = false;
251 
252   /**
253    * @notice Used for checking validity of Guardian
254    */
255   uint256 public guardianExpiration = block.timestamp.add(78 weeks); // Guardian expires in 1.5 years
256     
257   /**
258    * @notice used for tracking freeze timestamp
259    */ 
260   mapping(address => uint256) internal lastFrozen;
261   
262   uint256 public freezeDelay = 14 days; // Delay between freezing the same target multiple times to avoid abuse
263    
264   /**
265    * @notice Used for balance of the users and allowances
266    */
267   mapping(address => uint256) internal _balances;
268 
269   mapping(address => mapping(address => uint256)) internal _allowedBalances;
270 
271   bool public initialized = false;
272 
273   uint256 public currentSupply;
274 }
275 
276 // File: contracts/token/TokenInterface.sol
277 
278 // SPDX-License-Identifier: MIT
279 
280 pragma solidity 0.5.16;
281 
282 
283 
284 contract TokenInterface is TokenStorage, GovernanceStorage {
285 
286     /// @notice An event thats emitted when an account changes its delegate
287     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
288 
289     /// @notice An event thats emitted when a delegate account's vote balance changes
290     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
291 
292     /*** Gov Events ***/
293 
294     /**
295      * @notice Event emitted when pendingGov is changed
296      */
297     event NewPendingGov(address oldPendingGov, address newPendingGov);
298 
299     /**
300      * @notice Event emitted when gov is changed
301      */
302     event NewGov(address oldGov, address newGov);
303 
304     /**
305      * @notice Event emitted when Emssion is changed
306      */
307     event NewEmission(address oldEmission, address newEmission);
308     
309     /**
310      * @notice Event emitted when Guardian is changed
311      */
312     event NewGuardian(address oldGuardian, address newGuardian);
313     
314     /**
315      * @notice Event emitted when the pause is triggered.
316      */
317     event Paused(address account);
318 
319     /**
320      * @dev Event emitted when the pause is lifted.
321      */
322     event Unpaused(address account);
323 
324     /* - ERC20 Events - */
325 
326     /**
327      * @notice EIP20 Transfer event
328      */
329     event Transfer(address indexed from, address indexed to, uint amount);
330 
331     /**
332      * @notice EIP20 Approval event
333      */
334     event Approval(address indexed owner, address indexed spender, uint amount);
335 
336     /* - Extra Events - */
337     /**
338      * @notice Tokens minted event
339      */
340     event Mint(address to, uint256 amount);
341     event Burn(address from, uint256 amount);
342 
343     // Public functions
344     function transfer(address to, uint256 value) external returns(bool);
345     function transferFrom(address from, address to, uint256 value) external returns(bool);
346     function balanceOf(address who) external view returns(uint256);
347     function allowance(address owner_, address spender) external view returns(uint256);
348     function approve(address spender, uint256 value) external returns (bool);
349     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
350     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
351     /* - Governance Functions - */
352     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
353 //    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
354     function delegate(address delegatee) external;
355     function delegates(address delegator) external view returns (address);
356     function getCurrentVotes(address account) external view returns (uint256);
357 
358     /* - Permissioned/Governance functions - */
359     function mint(address to, uint256 amount) external returns (bool);
360     function _setPendingGov(address pendingGov_) external;
361     function _acceptGov() external;
362 }
363 
364 // File: contracts/token/Governance.sol
365 
366 pragma solidity 0.5.16;
367 
368 
369 /* Copyright 2020 Compound Labs, Inc.
370 
371 Redistribution and use in source and binary forms, with or without modification, are permitted
372 provided that the following conditions are met:
373 
374 1. Redistributions of source code must retain the above copyright notice, this list of conditions
375 and the following disclaimer.
376 
377 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
378 and the following disclaimer in the documentation and/or other materials provided with the
379 distribution.
380 
381 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse
382 or promote products derived from this software without specific prior written permission.
383 
384 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
385 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
386 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
387 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
388 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
389 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
390 IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
391 OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
392 
393 
394 
395 contract GovernanceToken is TokenInterface {
396 
397     /// @notice An event emitted when an account changes its delegate
398     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
399 
400     /// @notice An event emitted when a delegate account's vote balance changes
401     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
402 
403     /**
404      * @notice Get delegatee for an address delegating
405      * @param delegator The address to get delegatee for
406      */
407     function delegates(address delegator)
408         external
409         view
410         returns (address)
411     {
412         return _delegates[delegator];
413     }
414 
415    /**
416     * @notice Delegate votes from `msg.sender` to `delegatee`
417     * @param delegatee The address to delegate votes to
418     */
419     function delegate(address delegatee) external {
420         return _delegate(msg.sender, delegatee);
421     }
422 
423     /**
424      * @notice Gets the current votes balance for `account`
425      * @param account The address to get votes balance
426      * @return The number of current votes for `account`
427      */
428     function getCurrentVotes(address account)
429         external
430         view
431         returns (uint256)
432     {
433         uint32 nCheckpoints = numCheckpoints[account];
434         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
435     }
436 
437     /**
438      * @notice Determine the prior number of votes for an account as of a block number
439      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
440      * @param account The address of the account to check
441      * @param blockNumber The block number to get the vote balance at
442      * @return The number of votes the account had as of the given block
443      */
444     function getPriorVotes(address account, uint blockNumber)
445         external
446         view
447         returns (uint256)
448     {
449         require(blockNumber < block.number, "LIFE::getPriorVotes: not yet determined");
450 
451         uint32 nCheckpoints = numCheckpoints[account];
452         if (nCheckpoints == 0) {
453             return 0;
454         }
455 
456         // First check most recent balance
457         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
458             return checkpoints[account][nCheckpoints - 1].votes;
459         }
460 
461         // Next check implicit zero balance
462         if (checkpoints[account][0].fromBlock > blockNumber) {
463             return 0;
464         }
465 
466         uint32 lower = 0;
467         uint32 upper = nCheckpoints - 1;
468         while (upper > lower) {
469             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
470             Checkpoint memory cp = checkpoints[account][center];
471             if (cp.fromBlock == blockNumber) {
472                 return cp.votes;
473             } else if (cp.fromBlock < blockNumber) {
474                 lower = center;
475             } else {
476                 upper = center - 1;
477             }
478         }
479         return checkpoints[account][lower].votes;
480     }
481 
482     function _delegate(address delegator, address delegatee)
483         internal
484     {
485         address currentDelegate = _delegates[delegator];
486         uint256 delegatorBalance = _balances[delegator];
487         _delegates[delegator] = delegatee;
488 
489         emit DelegateChanged(delegator, currentDelegate, delegatee);
490 
491         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
492     }
493 
494     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
495         if (srcRep != dstRep && amount > 0) {
496             if (srcRep != address(0)) {
497                 // decrease old representative
498                 uint32 srcRepNum = numCheckpoints[srcRep];
499                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
500                 uint256 srcRepNew = srcRepOld.sub(amount);
501                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
502             }
503 
504             if (dstRep != address(0)) {
505                 // increase new representative
506                 uint32 dstRepNum = numCheckpoints[dstRep];
507                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
508                 uint256 dstRepNew = dstRepOld.add(amount);
509                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
510             }
511         }
512     }
513 
514     function _writeCheckpoint(
515         address delegatee,
516         uint32 nCheckpoints,
517         uint256 oldVotes,
518         uint256 newVotes
519     )
520         internal
521     {
522         uint32 blockNumber = safe32(block.number, "LIFE::_writeCheckpoint: block number exceeds 32 bits");
523 
524         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
525             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
526         } else {
527             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
528             numCheckpoints[delegatee] = nCheckpoints + 1;
529         }
530 
531         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
532     }
533 
534     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
535         require(n < 2**32, errorMessage);
536         return uint32(n);
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
541 
542 pragma solidity ^0.5.0;
543 
544 /**
545  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
546  * the optional functions; to access them see {ERC20Detailed}.
547  */
548 interface IERC20 {
549     /**
550      * @dev Returns the amount of tokens in existence.
551      */
552     function totalSupply() external view returns (uint256);
553 
554     /**
555      * @dev Returns the amount of tokens owned by `account`.
556      */
557     function balanceOf(address account) external view returns (uint256);
558 
559     /**
560      * @dev Moves `amount` tokens from the caller's account to `recipient`.
561      *
562      * Returns a boolean value indicating whether the operation succeeded.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transfer(address recipient, uint256 amount) external returns (bool);
567 
568     /**
569      * @dev Returns the remaining number of tokens that `spender` will be
570      * allowed to spend on behalf of `owner` through {transferFrom}. This is
571      * zero by default.
572      *
573      * This value changes when {approve} or {transferFrom} are called.
574      */
575     function allowance(address owner, address spender) external view returns (uint256);
576 
577     /**
578      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
579      *
580      * Returns a boolean value indicating whether the operation succeeded.
581      *
582      * IMPORTANT: Beware that changing an allowance with this method brings the risk
583      * that someone may use both the old and the new allowance by unfortunate
584      * transaction ordering. One possible solution to mitigate this race
585      * condition is to first reduce the spender's allowance to 0 and set the
586      * desired value afterwards:
587      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
588      *
589      * Emits an {Approval} event.
590      */
591     function approve(address spender, uint256 amount) external returns (bool);
592 
593     /**
594      * @dev Moves `amount` tokens from `sender` to `recipient` using the
595      * allowance mechanism. `amount` is then deducted from the caller's
596      * allowance.
597      *
598      * Returns a boolean value indicating whether the operation succeeded.
599      *
600      * Emits a {Transfer} event.
601      */
602     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
603 
604     /**
605      * @dev Emitted when `value` tokens are moved from one account (`from`) to
606      * another (`to`).
607      *
608      * Note that `value` may be zero.
609      */
610     event Transfer(address indexed from, address indexed to, uint256 value);
611 
612     /**
613      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
614      * a call to {approve}. `value` is the new allowance.
615      */
616     event Approval(address indexed owner, address indexed spender, uint256 value);
617 }
618 
619 // File: @openzeppelin/contracts/utils/Address.sol
620 
621 pragma solidity ^0.5.5;
622 
623 /**
624  * @dev Collection of functions related to the address type
625  */
626 library Address {
627     /**
628      * @dev Returns true if `account` is a contract.
629      *
630      * [IMPORTANT]
631      * ====
632      * It is unsafe to assume that an address for which this function returns
633      * false is an externally-owned account (EOA) and not a contract.
634      *
635      * Among others, `isContract` will return false for the following 
636      * types of addresses:
637      *
638      *  - an externally-owned account
639      *  - a contract in construction
640      *  - an address where a contract will be created
641      *  - an address where a contract lived, but was destroyed
642      * ====
643      */
644     function isContract(address account) internal view returns (bool) {
645         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
646         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
647         // for accounts without code, i.e. `keccak256('')`
648         bytes32 codehash;
649         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
650         // solhint-disable-next-line no-inline-assembly
651         assembly { codehash := extcodehash(account) }
652         return (codehash != accountHash && codehash != 0x0);
653     }
654 
655     /**
656      * @dev Converts an `address` into `address payable`. Note that this is
657      * simply a type cast: the actual underlying value is not changed.
658      *
659      * _Available since v2.4.0._
660      */
661     function toPayable(address account) internal pure returns (address payable) {
662         return address(uint160(account));
663     }
664 
665     /**
666      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
667      * `recipient`, forwarding all available gas and reverting on errors.
668      *
669      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
670      * of certain opcodes, possibly making contracts go over the 2300 gas limit
671      * imposed by `transfer`, making them unable to receive funds via
672      * `transfer`. {sendValue} removes this limitation.
673      *
674      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
675      *
676      * IMPORTANT: because control is transferred to `recipient`, care must be
677      * taken to not create reentrancy vulnerabilities. Consider using
678      * {ReentrancyGuard} or the
679      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
680      *
681      * _Available since v2.4.0._
682      */
683     function sendValue(address payable recipient, uint256 amount) internal {
684         require(address(this).balance >= amount, "Address: insufficient balance");
685 
686         // solhint-disable-next-line avoid-call-value
687         (bool success, ) = recipient.call.value(amount)("");
688         require(success, "Address: unable to send value, recipient may have reverted");
689     }
690 }
691 
692 // File: @openzeppelin/contracts/access/Roles.sol
693 pragma solidity ^0.5.0;
694 
695 /**
696  * @title Roles
697  * @dev Library for managing addresses assigned to a Role.
698  */
699 library Roles {
700     struct Role {
701         mapping (address => bool) bearer;
702     }
703 
704     /**
705      * @dev Give an account access to this role.
706      */
707     function add(Role storage role, address account) internal {
708         require(!has(role, account), "Roles: account already has role");
709         role.bearer[account] = true;
710     }
711 
712     /**
713      * @dev Remove an account's access to this role.
714      */
715     function remove(Role storage role, address account) internal {
716         require(has(role, account), "Roles: account does not have role");
717         role.bearer[account] = false;
718     }
719 
720     /**
721      * @dev Check if an account has this role.
722      * @return bool
723      */
724     function has(Role storage role, address account) internal view returns (bool) {
725         require(account != address(0), "Roles: account is the zero address");
726         return role.bearer[account];
727     }
728 }
729 
730 // File: Modifier from : @openzeppelin/contracts/access/roles/MinterRole.sol
731 
732 pragma solidity ^0.5.0;
733 
734 contract Frozen {
735     using Roles for Roles.Role;
736 
737     event AccountFrozen(address indexed account);
738     event AccountUnfrozen(address indexed account);
739 
740     Roles.Role private _frozen;
741 
742     modifier checkFrozen(address from) {
743         require(!isFrozen(from), "Frozen: Sender's tranfers are frozen");
744         _;
745     }
746 
747     function isFrozen(address account) public view returns (bool) {
748         return _frozen.has(account);
749     }
750 
751 
752     function _freezeAccount(address account) internal {
753         _frozen.add(account);
754         emit AccountFrozen(account);
755     }
756 
757     function _unfreezeAccount(address account) internal {
758         _frozen.remove(account);
759         emit AccountUnfrozen(account);
760     }
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
764 
765 pragma solidity ^0.5.0;
766 
767 /**
768  * @title SafeERC20
769  * @dev Wrappers around ERC20 operations that throw on failure (when the token
770  * contract returns false). Tokens that return no value (and instead revert or
771  * throw on failure) are also supported, non-reverting calls are assumed to be
772  * successful.
773  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
774  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
775  */
776 library SafeERC20 {
777     using SafeMath for uint256;
778     using Address for address;
779 
780     function safeTransfer(IERC20 token, address to, uint256 value) internal {
781         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
782     }
783 
784     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
785         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
786     }
787 
788     function safeApprove(IERC20 token, address spender, uint256 value) internal {
789         // safeApprove should only be called when setting an initial allowance,
790         // or when resetting it to zero. To increase and decrease it, use
791         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
792         // solhint-disable-next-line max-line-length
793         require((value == 0) || (token.allowance(address(this), spender) == 0),
794             "SafeERC20: approve from non-zero to non-zero allowance"
795         );
796         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
797     }
798 
799     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
800         uint256 newAllowance = token.allowance(address(this), spender).add(value);
801         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
802     }
803 
804     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
805         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
806         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
807     }
808 
809     /**
810      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
811      * on the return value: the return value is optional (but if data is returned, it must not be false).
812      * @param token The token targeted by the call.
813      * @param data The call data (encoded using abi.encode or one of its variants).
814      */
815     function callOptionalReturn(IERC20 token, bytes memory data) private {
816         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
817         // we're implementing it ourselves.
818 
819         // A Solidity high level call has three parts:
820         //  1. The target address is checked to verify it contains contract code
821         //  2. The call itself is made, and success asserted
822         //  3. The return value is decoded, which in turn checks the size of the returned data.
823         // solhint-disable-next-line max-line-length
824         require(address(token).isContract(), "SafeERC20: call to non-contract");
825 
826         // solhint-disable-next-line avoid-low-level-calls
827         (bool success, bytes memory returndata) = address(token).call(data);
828         require(success, "SafeERC20: low-level call failed");
829 
830         if (returndata.length > 0) { // Return data is optional
831             // solhint-disable-next-line max-line-length
832             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
833         }
834     }
835 }
836 
837 // File: contracts/LIFE.sol
838 
839 // SPDX-License-Identifier: GPL-3.0-or-later
840 
841 pragma solidity 0.5.16;
842 
843 
844 
845 
846 contract LIFEToken is GovernanceToken, Frozen {
847 
848   // Modifiers
849   modifier onlyGov() {
850     require(msg.sender == gov, "only governance");
851     _;
852   }
853   modifier onlyMinter() {
854     require(
855       msg.sender == emission || msg.sender == gov,
856       "not minter"
857     );
858     _;
859   }
860 
861   modifier onlyEmergency() {
862     require(
863       msg.sender == guardian || msg.sender == gov,
864       "not guardian or governor"
865     );
866     _;
867   }
868 
869   modifier whenNotPaused() {
870     require(_paused == false, "Pausable: paused");
871     _;
872   }
873 
874   modifier validRecipient(address to) {
875     require(to != address(0x0));
876     require(to != address(this));
877     _;
878   }
879 
880   function initialize(
881     string memory name_,
882     string memory symbol_,
883     uint8 decimals_
884   )
885   public
886   {
887     require(initialized == false, "already initialized");
888     name = name_;
889     symbol = symbol_;
890     decimals = decimals_;
891   }
892 
893   /**
894   * @notice Allows the pausing and unpausing of certain functions .
895   * @dev Limited to onlyMinter modifier
896   */
897   function pause()
898   public
899   onlyEmergency
900   {
901     _paused = true;
902     emit Paused(msg.sender);
903   }
904 
905   function unpause()
906   public
907   onlyEmergency
908   {
909     _paused = false;
910     emit Unpaused(msg.sender);
911   }
912 
913   /**
914   * @notice Mints new tokens, increasing  currentSupply .
915   * @dev Limited to onlyMinter modifier
916   */
917   function mint(address to, uint256 amount)
918   external
919   onlyMinter
920   whenNotPaused
921   returns (bool)
922   {
923     _mint(to, amount);
924     return true;
925   }
926 
927   function _mint(address to, uint256 amount)
928   internal
929   {
930 
931     require(currentSupply.add(amount) <= totalSupply, "Emission exceeds total supply");
932     // increase currentSupply
933     currentSupply = currentSupply.add(amount);
934 
935     // add balance
936     _balances[to] = _balances[to].add(amount);
937 
938     // add delegates to the minter
939     _moveDelegates(address(0), _delegates[to], amount);
940     emit Mint(to, amount);
941     emit Transfer(address(0), to, amount);
942   }
943 
944   /**
945   * @notice Burns tokens, decreasing totalSupply, currentSupply, and a users balance.
946   */
947   function burn(uint256 amount)
948   external
949   returns (bool)
950   { 
951     _burn(msg.sender, amount);
952     return true;
953   }
954 
955   function _burn(address from, uint256 amount)
956   internal
957   {
958     // decrease totalSupply
959     totalSupply = totalSupply.sub(amount);
960 
961     // decrease currentSupply
962     currentSupply = currentSupply.sub(amount);
963 
964     // sub balance, will revert on underflow
965     _balances[from] = _balances[from].sub(amount);
966 
967     // remove delegates from the minter
968     _moveDelegates(_delegates[from], address(0), amount);
969     emit Burn(from, amount);
970     emit Transfer(from, address(0), amount);
971   }
972 
973   /* - ERC20 functionality - */
974 
975   /**
976   * @dev Transfer tokens to a specified address.
977   * @param to The address to transfer to.
978   * @param value The amount to be transferred.
979   * @return True on success, false otherwise.
980   */
981   function transfer(address to, uint256 value)
982   external
983   validRecipient(to)
984   checkFrozen(msg.sender)
985   whenNotPaused
986   returns (bool)
987   {
988 
989     // sub from balance of sender
990     _balances[msg.sender] = _balances[msg.sender].sub(value);
991 
992     // add to balance of receiver
993     _balances[to] = _balances[to].add(value);
994     emit Transfer(msg.sender, to, value);
995 
996     _moveDelegates(_delegates[msg.sender], _delegates[to], value);
997     return true;
998   }
999 
1000   /**
1001   * @dev Transfer tokens from one address to another.
1002   * @param from The address you want to send tokens from.
1003   * @param to The address you want to transfer to.
1004   * @param value The amount of tokens to be transferred.
1005   */
1006   function transferFrom(address from, address to, uint256 value)
1007   external
1008   validRecipient(to)
1009   checkFrozen(from)
1010   whenNotPaused
1011   returns (bool)
1012   {
1013     // decrease allowance
1014     _allowedBalances[from][msg.sender] = _allowedBalances[from][msg.sender].sub(value);
1015 
1016     // sub from balance
1017     _balances[from] = _balances[from].sub(value);
1018     _balances[to] = _balances[to].add(value);
1019     emit Transfer(from, to, value);
1020 
1021     _moveDelegates(_delegates[from], _delegates[to], value);
1022     return true;
1023   }
1024 
1025   /**
1026   * @param who The address to query.
1027   * @return The balance of the specified address.
1028   */
1029   function balanceOf(address who)
1030   external
1031   view
1032   returns (uint256)
1033   {
1034     return _balances[who];
1035   }
1036 
1037 
1038   /**
1039    * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1040    * @param owner_ The address which owns the funds.
1041    * @param spender The address which will spend the funds.
1042    * @return The number of tokens still available for the spender.
1043    */
1044   function allowance(address owner_, address spender)
1045   external
1046   view
1047   returns (uint256)
1048   {
1049     return _allowedBalances[owner_][spender];
1050   }
1051 
1052   /**
1053    * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1054    * msg.sender. This method is included for ERC20 compatibility.
1055    * increaseAllowance and decreaseAllowance should be used instead.
1056    * Changing an allowance with this method brings the risk that someone may transfer both
1057    * the old and the new allowance - if they are both greater than zero - if a transfer
1058    * transaction is mined before the later approve() call is mined.
1059    *
1060    * @param spender The address which will spend the funds.
1061    * @param value The amount of tokens to be spent.
1062    */
1063   function approve(address spender, uint256 value)
1064   external
1065   returns (bool)
1066   {
1067     _allowedBalances[msg.sender][spender] = value;
1068     emit Approval(msg.sender, spender, value);
1069     return true;
1070   }
1071 
1072   /**
1073    * @dev Increase the amount of tokens that an owner has allowed to a spender.
1074    * This method should be used instead of approve() to avoid the double approval vulnerability
1075    * described above.
1076    * @param spender The address which will spend the funds.
1077    * @param addedValue The amount of tokens to increase the allowance by.
1078    */
1079   function increaseAllowance(address spender, uint256 addedValue)
1080   external
1081   returns (bool)
1082   {
1083     _allowedBalances[msg.sender][spender] =
1084     _allowedBalances[msg.sender][spender].add(addedValue);
1085     emit Approval(msg.sender, spender, _allowedBalances[msg.sender][spender]);
1086     return true;
1087   }
1088 
1089   /**
1090    * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1091    *
1092    * @param spender The address which will spend the funds.
1093    * @param subtractedValue The amount of tokens to decrease the allowance by.
1094    */
1095   function decreaseAllowance(address spender, uint256 subtractedValue)
1096   external
1097   returns (bool)
1098   {
1099     uint256 oldValue = _allowedBalances[msg.sender][spender];
1100     if (subtractedValue >= oldValue) {
1101       _allowedBalances[msg.sender][spender] = 0;
1102     } else {
1103       _allowedBalances[msg.sender][spender] = oldValue.sub(subtractedValue);
1104     }
1105     emit Approval(msg.sender, spender, _allowedBalances[msg.sender][spender]);
1106     return true;
1107   }
1108 
1109   /* - Governance Functions - */
1110 
1111   /** @notice sets the emission
1112    * @param emission_ The address of the emission contract to use for authentication.
1113    */
1114   function _setEmission(address emission_)
1115   external
1116   onlyGov
1117   {
1118     address oldEmission = emission;
1119     emission = emission_;
1120     emit NewEmission(oldEmission, emission_);
1121   }
1122 
1123   /** @notice sets the emission
1124    * @param guardian_ The address of the guardian contract to use for authentication.
1125    */
1126   function _setGuardian(address guardian_)
1127   external
1128   onlyEmergency
1129   {
1130     require(block.timestamp < guardianExpiration); // Can only set new guardian if guardian powers havn't expired yet
1131     address oldGuardian = guardian;
1132     guardian = guardian_;
1133     emit NewGuardian(oldGuardian, guardian_);
1134   }
1135 
1136   function freezeTargetFunds(address target)
1137   external
1138   onlyEmergency
1139   {
1140     require(lastFrozen[target].add(freezeDelay) < block.timestamp, "Target was Frozen recently");
1141     lastFrozen[target] = block.timestamp;
1142     _freezeAccount(target);
1143   }
1144 
1145   function unfreezeTargetFunds(address target)
1146   external
1147   onlyEmergency
1148   {
1149     _unfreezeAccount(target);
1150   }
1151   
1152   /** @notice lets msg.sender abolish guardian
1153    *
1154    */
1155   function abolishGuardian()
1156   external
1157   {
1158     require(msg.sender == guardian || block.timestamp >= guardianExpiration); // Can be abolished by anyone after expiration or anytime by guardian themselves
1159     guardian = address(0);
1160   }
1161 
1162   /** @notice sets the pendingGov
1163    * @param pendingGov_ The address of the governor contract to use for authentication.
1164    */
1165   function _setPendingGov(address pendingGov_)
1166   external
1167   onlyGov
1168   {
1169     address oldPendingGov = pendingGov;
1170     pendingGov = pendingGov_;
1171     emit NewPendingGov(oldPendingGov, pendingGov_);
1172   }
1173 
1174   /** @notice lets msg.sender accept governance
1175    *
1176    */
1177   function _acceptGov()
1178   external
1179   {
1180     require(msg.sender == pendingGov, "!pending");
1181     address oldGov = gov;
1182     gov = pendingGov;
1183     pendingGov = address(0);
1184     emit NewGov(oldGov, gov);
1185   }
1186 
1187   // Rescue tokens
1188   function rescueTokens(
1189     address token,
1190     address to,
1191     uint256 amount
1192   )
1193   external
1194   onlyGov
1195   returns (bool)
1196   {
1197     // transfer to
1198     SafeERC20.safeTransfer(IERC20(token), to, amount);
1199     return true;
1200   }
1201 }
1202 
1203 contract LIFE is LIFEToken {
1204 
1205   constructor() public {}
1206 
1207   /**
1208    * @notice Initialize the new money market
1209    * @param name_ ERC-20 name of this token
1210    * @param symbol_ ERC-20 symbol of this token
1211    * @param decimals_ ERC-20 decimal precision of this token
1212    */
1213   function initialize(
1214     string memory name_,
1215     string memory symbol_,
1216     uint8 decimals_,
1217     address initial_owner,
1218     uint256 initSupply_,
1219     uint256 totalSupply_
1220   )
1221   public
1222   {
1223     super.initialize(name_, symbol_, decimals_);
1224 
1225     initialized = true;
1226     currentSupply = initSupply_;
1227     totalSupply = totalSupply_;
1228     _balances[initial_owner] = currentSupply;
1229     gov = initial_owner;
1230     guardian = initial_owner;
1231   }
1232 }