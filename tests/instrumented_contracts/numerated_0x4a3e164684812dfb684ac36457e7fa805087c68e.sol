1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.5.15;
4 
5 /* Copyright 2020 Compound Labs, Inc.
6 
7 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
8 
9 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
10 
11 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
12 
13 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
14 
15 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
16 
17 contract YUANGovernanceStorage {
18     /// @notice A record of each accounts delegate
19     mapping(address => address) internal _delegates;
20 
21     /// @notice A checkpoint for marking number of votes from a given block
22     struct Checkpoint {
23         uint32 fromBlock;
24         uint256 votes;
25     }
26 
27     /// @notice A record of votes checkpoints for each account, by index
28     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
29 
30     /// @notice The number of checkpoints for each account
31     mapping(address => uint32) public numCheckpoints;
32 
33     /// @notice The EIP-712 typehash for the contract's domain
34     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
35         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
36     );
37 
38     /// @notice The EIP-712 typehash for the delegation struct used by the contract
39     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
40         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
41     );
42 
43     /// @notice A record of states for signing / validating signatures
44     mapping(address => uint256) public nonces;
45 }
46 
47 // Storage for a YUAN token
48 contract YUANTokenStorage {
49     using SafeMath for uint256;
50 
51     /**
52      * @dev Guard variable for re-entrancy checks. Not currently used
53      */
54     bool internal _notEntered;
55 
56     /**
57      * @notice EIP-20 token name for this token
58      */
59     string public name;
60 
61     /**
62      * @notice EIP-20 token symbol for this token
63      */
64     string public symbol;
65 
66     /**
67      * @notice EIP-20 token decimals for this token
68      */
69     uint8 public decimals;
70 
71     /**
72      * @notice Governor for this contract
73      */
74     address public gov;
75 
76     /**
77      * @notice Pending governance for this contract
78      */
79     address public pendingGov;
80 
81     /**
82      * @notice Approved rebaser for this contract
83      */
84     address public rebaser;
85 
86     /**
87      * @notice Approved migrator for this contract
88      */
89     address public migrator;
90 
91     /**
92      * @notice Incentivizer address of YUAN protocol
93      */
94     address public incentivizer;
95 
96     /**
97      * @notice Total supply of YUANs
98      */
99     uint256 public totalSupply;
100 
101     /**
102      * @notice Internal decimals used to handle scaling factor
103      */
104     uint256 public constant internalDecimals = 10**24;
105 
106     /**
107      * @notice Used for percentage maths
108      */
109     uint256 public constant BASE = 10**18;
110 
111     /**
112      * @notice Scaling factor that adjusts everyone's balances
113      */
114     uint256 public yuansScalingFactor;
115 
116     mapping(address => uint256) internal _yuanBalances;
117 
118     mapping(address => mapping(address => uint256)) internal _allowedFragments;
119 
120     uint256 public initSupply;
121 
122     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
123     bytes32
124         public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
125     bytes32 public DOMAIN_SEPARATOR;
126 }
127 
128 contract YUANTokenInterface is YUANTokenStorage, YUANGovernanceStorage {
129     /// @notice An event thats emitted when an account changes its delegate
130     event DelegateChanged(
131         address indexed delegator,
132         address indexed fromDelegate,
133         address indexed toDelegate
134     );
135 
136     /// @notice An event thats emitted when a delegate account's vote balance changes
137     event DelegateVotesChanged(
138         address indexed delegate,
139         uint256 previousBalance,
140         uint256 newBalance
141     );
142 
143     /**
144      * @notice Event emitted when tokens are rebased
145      */
146     event Rebase(
147         uint256 epoch,
148         uint256 prevYuansScalingFactor,
149         uint256 newYuansScalingFactor
150     );
151 
152     /*** Gov Events ***/
153 
154     /**
155      * @notice Event emitted when pendingGov is changed
156      */
157     event NewPendingGov(address oldPendingGov, address newPendingGov);
158 
159     /**
160      * @notice Event emitted when gov is changed
161      */
162     event NewGov(address oldGov, address newGov);
163 
164     /**
165      * @notice Sets the rebaser contract
166      */
167     event NewRebaser(address oldRebaser, address newRebaser);
168 
169     /**
170      * @notice Sets the migrator contract
171      */
172     event NewMigrator(address oldMigrator, address newMigrator);
173 
174     /**
175      * @notice Sets the incentivizer contract
176      */
177     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
178 
179     /* - ERC20 Events - */
180 
181     /**
182      * @notice EIP20 Transfer event
183      */
184     event Transfer(address indexed from, address indexed to, uint256 amount);
185 
186     /**
187      * @notice EIP20 Approval event
188      */
189     event Approval(
190         address indexed owner,
191         address indexed spender,
192         uint256 amount
193     );
194 
195     /* - Extra Events - */
196     /**
197      * @notice Tokens minted event
198      */
199     event Mint(address to, uint256 amount);
200 
201     // Public functions
202     function transfer(address to, uint256 value) external returns (bool);
203 
204     function transferFrom(
205         address from,
206         address to,
207         uint256 value
208     ) external returns (bool);
209 
210     function balanceOf(address who) external view returns (uint256);
211 
212     function balanceOfUnderlying(address who) external view returns (uint256);
213 
214     function allowance(address owner_, address spender)
215         external
216         view
217         returns (uint256);
218 
219     function approve(address spender, uint256 value) external returns (bool);
220 
221     function increaseAllowance(address spender, uint256 addedValue)
222         external
223         returns (bool);
224 
225     function decreaseAllowance(address spender, uint256 subtractedValue)
226         external
227         returns (bool);
228 
229     function maxScalingFactor() external view returns (uint256);
230 
231     function yuanToFragment(uint256 yuan) external view returns (uint256);
232 
233     function fragmentToYuan(uint256 value) external view returns (uint256);
234 
235     /* - Governance Functions - */
236     function getPriorVotes(address account, uint256 blockNumber)
237         external
238         view
239         returns (uint256);
240 
241     function delegateBySig(
242         address delegatee,
243         uint256 nonce,
244         uint256 expiry,
245         uint8 v,
246         bytes32 r,
247         bytes32 s
248     ) external;
249 
250     function delegate(address delegatee) external;
251 
252     function delegates(address delegator) external view returns (address);
253 
254     function getCurrentVotes(address account) external view returns (uint256);
255 
256     /* - Permissioned/Governance functions - */
257     function mint(address to, uint256 amount) external returns (bool);
258 
259     function rebase(
260         uint256 epoch,
261         uint256 indexDelta,
262         bool positive
263     ) external returns (uint256);
264 
265     function _setRebaser(address rebaser_) external;
266 
267     function _setIncentivizer(address incentivizer_) external;
268 
269     function _setPendingGov(address pendingGov_) external;
270 
271     function _acceptGov() external;
272 }
273 
274 contract YUANGovernanceToken is YUANTokenInterface {
275     /// @notice An event thats emitted when an account changes its delegate
276     event DelegateChanged(
277         address indexed delegator,
278         address indexed fromDelegate,
279         address indexed toDelegate
280     );
281 
282     /// @notice An event thats emitted when a delegate account's vote balance changes
283     event DelegateVotesChanged(
284         address indexed delegate,
285         uint256 previousBalance,
286         uint256 newBalance
287     );
288 
289     /**
290      * @notice Get delegatee for an address delegating
291      * @param delegator The address to get delegatee for
292      */
293     function delegates(address delegator) external view returns (address) {
294         return _delegates[delegator];
295     }
296 
297     /**
298      * @notice Delegate votes from `msg.sender` to `delegatee`
299      * @param delegatee The address to delegate votes to
300      */
301     function delegate(address delegatee) external {
302         return _delegate(msg.sender, delegatee);
303     }
304 
305     /**
306      * @notice Delegates votes from signatory to `delegatee`
307      * @param delegatee The address to delegate votes to
308      * @param nonce The contract state required to match the signature
309      * @param expiry The time at which to expire the signature
310      * @param v The recovery byte of the signature
311      * @param r Half of the ECDSA signature pair
312      * @param s Half of the ECDSA signature pair
313      */
314     function delegateBySig(
315         address delegatee,
316         uint256 nonce,
317         uint256 expiry,
318         uint8 v,
319         bytes32 r,
320         bytes32 s
321     ) external {
322         bytes32 structHash = keccak256(
323             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
324         );
325 
326         bytes32 digest = keccak256(
327             abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash)
328         );
329 
330         address signatory = ecrecover(digest, v, r, s);
331         require(
332             signatory != address(0),
333             "YUAN::delegateBySig: invalid signature"
334         );
335         require(
336             nonce == nonces[signatory]++,
337             "YUAN::delegateBySig: invalid nonce"
338         );
339         require(now <= expiry, "YUAN::delegateBySig: signature expired");
340         return _delegate(signatory, delegatee);
341     }
342 
343     /**
344      * @notice Gets the current votes balance for `account`
345      * @param account The address to get votes balance
346      * @return The number of current votes for `account`
347      */
348     function getCurrentVotes(address account) external view returns (uint256) {
349         uint32 nCheckpoints = numCheckpoints[account];
350         return
351             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
352     }
353 
354     /**
355      * @notice Determine the prior number of votes for an account as of a block number
356      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
357      * @param account The address of the account to check
358      * @param blockNumber The block number to get the vote balance at
359      * @return The number of votes the account had as of the given block
360      */
361     function getPriorVotes(address account, uint256 blockNumber)
362         external
363         view
364         returns (uint256)
365     {
366         require(
367             blockNumber < block.number,
368             "YUAN::getPriorVotes: not yet determined"
369         );
370 
371         uint32 nCheckpoints = numCheckpoints[account];
372         if (nCheckpoints == 0) {
373             return 0;
374         }
375 
376         // First check most recent balance
377         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
378             return checkpoints[account][nCheckpoints - 1].votes;
379         }
380 
381         // Next check implicit zero balance
382         if (checkpoints[account][0].fromBlock > blockNumber) {
383             return 0;
384         }
385 
386         uint32 lower = 0;
387         uint32 upper = nCheckpoints - 1;
388         while (upper > lower) {
389             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
390             Checkpoint memory cp = checkpoints[account][center];
391             if (cp.fromBlock == blockNumber) {
392                 return cp.votes;
393             } else if (cp.fromBlock < blockNumber) {
394                 lower = center;
395             } else {
396                 upper = center - 1;
397             }
398         }
399         return checkpoints[account][lower].votes;
400     }
401 
402     function _delegate(address delegator, address delegatee) internal {
403         address currentDelegate = _delegates[delegator];
404         uint256 delegatorBalance = _yuanBalances[delegator]; // balance of underlying YUANs (not scaled);
405         _delegates[delegator] = delegatee;
406 
407         emit DelegateChanged(delegator, currentDelegate, delegatee);
408 
409         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
410     }
411 
412     function _moveDelegates(
413         address srcRep,
414         address dstRep,
415         uint256 amount
416     ) internal {
417         if (srcRep != dstRep && amount > 0) {
418             if (srcRep != address(0)) {
419                 // decrease old representative
420                 uint32 srcRepNum = numCheckpoints[srcRep];
421                 uint256 srcRepOld = srcRepNum > 0
422                     ? checkpoints[srcRep][srcRepNum - 1].votes
423                     : 0;
424                 uint256 srcRepNew = srcRepOld.sub(amount);
425                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
426             }
427 
428             if (dstRep != address(0)) {
429                 // increase new representative
430                 uint32 dstRepNum = numCheckpoints[dstRep];
431                 uint256 dstRepOld = dstRepNum > 0
432                     ? checkpoints[dstRep][dstRepNum - 1].votes
433                     : 0;
434                 uint256 dstRepNew = dstRepOld.add(amount);
435                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
436             }
437         }
438     }
439 
440     function _writeCheckpoint(
441         address delegatee,
442         uint32 nCheckpoints,
443         uint256 oldVotes,
444         uint256 newVotes
445     ) internal {
446         uint32 blockNumber = safe32(
447             block.number,
448             "YUAN::_writeCheckpoint: block number exceeds 32 bits"
449         );
450 
451         if (
452             nCheckpoints > 0 &&
453             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
454         ) {
455             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
456         } else {
457             checkpoints[delegatee][nCheckpoints] = Checkpoint(
458                 blockNumber,
459                 newVotes
460             );
461             numCheckpoints[delegatee] = nCheckpoints + 1;
462         }
463 
464         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
465     }
466 
467     function safe32(uint256 n, string memory errorMessage)
468         internal
469         pure
470         returns (uint32)
471     {
472         require(n < 2**32, errorMessage);
473         return uint32(n);
474     }
475 
476     function getChainId() internal pure returns (uint256) {
477         uint256 chainId;
478         assembly {
479             chainId := chainid()
480         }
481         return chainId;
482     }
483 }
484 
485 /**
486  * @dev Interface of the ERC20 standard as defined in the EIP.
487  */
488 interface IERC20 {
489     /**
490      * @dev Returns the amount of tokens in existence.
491      */
492     function totalSupply() external view returns (uint256);
493 
494     /**
495      * @dev Returns the amount of tokens owned by `account`.
496      */
497     function balanceOf(address account) external view returns (uint256);
498 
499     /**
500      * @dev Moves `amount` tokens from the caller's account to `recipient`.
501      *
502      * Returns a boolean value indicating whether the operation succeeded.
503      *
504      * Emits a {Transfer} event.
505      */
506     function transfer(address recipient, uint256 amount)
507         external
508         returns (bool);
509 
510     /**
511      * @dev Returns the remaining number of tokens that `spender` will be
512      * allowed to spend on behalf of `owner` through {transferFrom}. This is
513      * zero by default.
514      *
515      * This value changes when {approve} or {transferFrom} are called.
516      */
517     function allowance(address owner, address spender)
518         external
519         view
520         returns (uint256);
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
524      *
525      * Returns a boolean value indicating whether the operation succeeded.
526      *
527      * IMPORTANT: Beware that changing an allowance with this method brings the risk
528      * that someone may use both the old and the new allowance by unfortunate
529      * transaction ordering. One possible solution to mitigate this race
530      * condition is to first reduce the spender's allowance to 0 and set the
531      * desired value afterwards:
532      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
533      *
534      * Emits an {Approval} event.
535      */
536     function approve(address spender, uint256 amount) external returns (bool);
537 
538     /**
539      * @dev Moves `amount` tokens from `sender` to `recipient` using the
540      * allowance mechanism. `amount` is then deducted from the caller's
541      * allowance.
542      *
543      * Returns a boolean value indicating whether the operation succeeded.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transferFrom(
548         address sender,
549         address recipient,
550         uint256 amount
551     ) external returns (bool);
552 
553     /**
554      * @dev Emitted when `value` tokens are moved from one account (`from`) to
555      * another (`to`).
556      *
557      * Note that `value` may be zero.
558      */
559     event Transfer(address indexed from, address indexed to, uint256 value);
560 
561     /**
562      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
563      * a call to {approve}. `value` is the new allowance.
564      */
565     event Approval(
566         address indexed owner,
567         address indexed spender,
568         uint256 value
569     );
570 }
571 
572 /**
573  * @dev Wrappers over Solidity's arithmetic operations with added overflow
574  * checks.
575  *
576  * Arithmetic operations in Solidity wrap on overflow. This can easily result
577  * in bugs, because programmers usually assume that an overflow raises an
578  * error, which is the standard behavior in high level programming languages.
579  * `SafeMath` restores this intuition by reverting the transaction when an
580  * operation overflows.
581  *
582  * Using this library instead of the unchecked operations eliminates an entire
583  * class of bugs, so it's recommended to use it always.
584  */
585 library SafeMath {
586     /**
587      * @dev Returns the addition of two unsigned integers, reverting on
588      * overflow.
589      *
590      * Counterpart to Solidity's `+` operator.
591      *
592      * Requirements:
593      *
594      * - Addition cannot overflow.
595      */
596     function add(uint256 a, uint256 b) internal pure returns (uint256) {
597         uint256 c = a + b;
598         require(c >= a, "SafeMath: addition overflow");
599 
600         return c;
601     }
602 
603     /**
604      * @dev Returns the subtraction of two unsigned integers, reverting on
605      * overflow (when the result is negative).
606      *
607      * Counterpart to Solidity's `-` operator.
608      *
609      * Requirements:
610      *
611      * - Subtraction cannot overflow.
612      */
613     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
614         return sub(a, b, "SafeMath: subtraction overflow");
615     }
616 
617     /**
618      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
619      * overflow (when the result is negative).
620      *
621      * Counterpart to Solidity's `-` operator.
622      *
623      * Requirements:
624      *
625      * - Subtraction cannot overflow.
626      */
627     function sub(
628         uint256 a,
629         uint256 b,
630         string memory errorMessage
631     ) internal pure returns (uint256) {
632         require(b <= a, errorMessage);
633         uint256 c = a - b;
634 
635         return c;
636     }
637 
638     /**
639      * @dev Returns the multiplication of two unsigned integers, reverting on
640      * overflow.
641      *
642      * Counterpart to Solidity's `*` operator.
643      *
644      * Requirements:
645      *
646      * - Multiplication cannot overflow.
647      */
648     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
649         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
650         // benefit is lost if 'b' is also tested.
651         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
652         if (a == 0) {
653             return 0;
654         }
655 
656         uint256 c = a * b;
657         require(c / a == b, "SafeMath: multiplication overflow");
658 
659         return c;
660     }
661 
662     /**
663      * @dev Returns the integer division of two unsigned integers. Reverts on
664      * division by zero. The result is rounded towards zero.
665      *
666      * Counterpart to Solidity's `/` operator. Note: this function uses a
667      * `revert` opcode (which leaves remaining gas untouched) while Solidity
668      * uses an invalid opcode to revert (consuming all remaining gas).
669      *
670      * Requirements:
671      *
672      * - The divisor cannot be zero.
673      */
674     function div(uint256 a, uint256 b) internal pure returns (uint256) {
675         return div(a, b, "SafeMath: division by zero");
676     }
677 
678     /**
679      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
680      * division by zero. The result is rounded towards zero.
681      *
682      * Counterpart to Solidity's `/` operator. Note: this function uses a
683      * `revert` opcode (which leaves remaining gas untouched) while Solidity
684      * uses an invalid opcode to revert (consuming all remaining gas).
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function div(
691         uint256 a,
692         uint256 b,
693         string memory errorMessage
694     ) internal pure returns (uint256) {
695         require(b > 0, errorMessage);
696         uint256 c = a / b;
697         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
698 
699         return c;
700     }
701 
702     /**
703      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
704      * Reverts when dividing by zero.
705      *
706      * Counterpart to Solidity's `%` operator. This function uses a `revert`
707      * opcode (which leaves remaining gas untouched) while Solidity uses an
708      * invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
715         return mod(a, b, "SafeMath: modulo by zero");
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * Reverts with custom message when dividing by zero.
721      *
722      * Counterpart to Solidity's `%` operator. This function uses a `revert`
723      * opcode (which leaves remaining gas untouched) while Solidity uses an
724      * invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function mod(
731         uint256 a,
732         uint256 b,
733         string memory errorMessage
734     ) internal pure returns (uint256) {
735         require(b != 0, errorMessage);
736         return a % b;
737     }
738 }
739 
740 /**
741  * @dev Collection of functions related to the address type
742  */
743 library Address {
744     /**
745      * @dev Returns true if `account` is a contract.
746      *
747      * [IMPORTANT]
748      * ====
749      * It is unsafe to assume that an address for which this function returns
750      * false is an externally-owned account (EOA) and not a contract.
751      *
752      * Among others, `isContract` will return false for the following
753      * types of addresses:
754      *
755      *  - an externally-owned account
756      *  - a contract in construction
757      *  - an address where a contract will be created
758      *  - an address where a contract lived, but was destroyed
759      * ====
760      */
761     function isContract(address account) internal view returns (bool) {
762         // This method relies in extcodesize, which returns 0 for contracts in
763         // construction, since the code is only stored at the end of the
764         // constructor execution.
765 
766         uint256 size;
767         // solhint-disable-next-line no-inline-assembly
768         assembly {
769             size := extcodesize(account)
770         }
771         return size > 0;
772     }
773 
774     /**
775      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
776      * `recipient`, forwarding all available gas and reverting on errors.
777      *
778      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
779      * of certain opcodes, possibly making contracts go over the 2300 gas limit
780      * imposed by `transfer`, making them unable to receive funds via
781      * `transfer`. {sendValue} removes this limitation.
782      *
783      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
784      *
785      * IMPORTANT: because control is transferred to `recipient`, care must be
786      * taken to not create reentrancy vulnerabilities. Consider using
787      * {ReentrancyGuard} or the
788      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
789      */
790     function sendValue(address payable recipient, uint256 amount) internal {
791         require(
792             address(this).balance >= amount,
793             "Address: insufficient balance"
794         );
795 
796         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
797         (bool success, ) = recipient.call.value(amount)("");
798         require(
799             success,
800             "Address: unable to send value, recipient may have reverted"
801         );
802     }
803 
804     /**
805      * @dev Performs a Solidity function call using a low level `call`. A
806      * plain`call` is an unsafe replacement for a function call: use this
807      * function instead.
808      *
809      * If `target` reverts with a revert reason, it is bubbled up by this
810      * function (like regular Solidity function calls).
811      *
812      * Returns the raw returned data. To convert to the expected return value,
813      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
814      *
815      * Requirements:
816      *
817      * - `target` must be a contract.
818      * - calling `target` with `data` must not revert.
819      *
820      * _Available since v3.1._
821      */
822     function functionCall(address target, bytes memory data)
823         internal
824         returns (bytes memory)
825     {
826         return functionCall(target, data, "Address: low-level call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
831      * `errorMessage` as a fallback revert reason when `target` reverts.
832      *
833      * _Available since v3.1._
834      */
835     function functionCall(
836         address target,
837         bytes memory data,
838         string memory errorMessage
839     ) internal returns (bytes memory) {
840         return _functionCallWithValue(target, data, 0, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but also transferring `value` wei to `target`.
846      *
847      * Requirements:
848      *
849      * - the calling contract must have an ETH balance of at least `value`.
850      * - the called Solidity function must be `payable`.
851      *
852      * _Available since v3.1._
853      */
854     function functionCallWithValue(
855         address target,
856         bytes memory data,
857         uint256 value
858     ) internal returns (bytes memory) {
859         return
860             functionCallWithValue(
861                 target,
862                 data,
863                 value,
864                 "Address: low-level call with value failed"
865             );
866     }
867 
868     /**
869      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
870      * with `errorMessage` as a fallback revert reason when `target` reverts.
871      *
872      * _Available since v3.1._
873      */
874     function functionCallWithValue(
875         address target,
876         bytes memory data,
877         uint256 value,
878         string memory errorMessage
879     ) internal returns (bytes memory) {
880         require(
881             address(this).balance >= value,
882             "Address: insufficient balance for call"
883         );
884         return _functionCallWithValue(target, data, value, errorMessage);
885     }
886 
887     function _functionCallWithValue(
888         address target,
889         bytes memory data,
890         uint256 weiValue,
891         string memory errorMessage
892     ) private returns (bytes memory) {
893         require(isContract(target), "Address: call to non-contract");
894 
895         // solhint-disable-next-line avoid-low-level-calls
896         (bool success, bytes memory returndata) = target.call.value(weiValue)(
897             data
898         );
899         if (success) {
900             return returndata;
901         } else {
902             // Look for revert reason and bubble it up if present
903             if (returndata.length > 0) {
904                 // The easiest way to bubble the revert reason is using memory via assembly
905 
906                 // solhint-disable-next-line no-inline-assembly
907                 assembly {
908                     let returndata_size := mload(returndata)
909                     revert(add(32, returndata), returndata_size)
910                 }
911             } else {
912                 revert(errorMessage);
913             }
914         }
915     }
916 }
917 
918 /**
919  * @title SafeERC20
920  * @dev Wrappers around ERC20 operations that throw on failure (when the token
921  * contract returns false). Tokens that return no value (and instead revert or
922  * throw on failure) are also supported, non-reverting calls are assumed to be
923  * successful.
924  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
925  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
926  */
927 library SafeERC20 {
928     using SafeMath for uint256;
929     using Address for address;
930 
931     function safeTransfer(
932         IERC20 token,
933         address to,
934         uint256 value
935     ) internal {
936         _callOptionalReturn(
937             token,
938             abi.encodeWithSelector(token.transfer.selector, to, value)
939         );
940     }
941 
942     function safeTransferFrom(
943         IERC20 token,
944         address from,
945         address to,
946         uint256 value
947     ) internal {
948         _callOptionalReturn(
949             token,
950             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
951         );
952     }
953 
954     /**
955      * @dev Deprecated. This function has issues similar to the ones found in
956      * {IERC20-approve}, and its usage is discouraged.
957      *
958      * Whenever possible, use {safeIncreaseAllowance} and
959      * {safeDecreaseAllowance} instead.
960      */
961     function safeApprove(
962         IERC20 token,
963         address spender,
964         uint256 value
965     ) internal {
966         // safeApprove should only be called when setting an initial allowance,
967         // or when resetting it to zero. To increase and decrease it, use
968         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
969         // solhint-disable-next-line max-line-length
970         require(
971             (value == 0) || (token.allowance(address(this), spender) == 0),
972             "SafeERC20: approve from non-zero to non-zero allowance"
973         );
974         _callOptionalReturn(
975             token,
976             abi.encodeWithSelector(token.approve.selector, spender, value)
977         );
978     }
979 
980     function safeIncreaseAllowance(
981         IERC20 token,
982         address spender,
983         uint256 value
984     ) internal {
985         uint256 newAllowance = token.allowance(address(this), spender).add(
986             value
987         );
988         _callOptionalReturn(
989             token,
990             abi.encodeWithSelector(
991                 token.approve.selector,
992                 spender,
993                 newAllowance
994             )
995         );
996     }
997 
998     function safeDecreaseAllowance(
999         IERC20 token,
1000         address spender,
1001         uint256 value
1002     ) internal {
1003         uint256 newAllowance = token.allowance(address(this), spender).sub(
1004             value,
1005             "SafeERC20: decreased allowance below zero"
1006         );
1007         _callOptionalReturn(
1008             token,
1009             abi.encodeWithSelector(
1010                 token.approve.selector,
1011                 spender,
1012                 newAllowance
1013             )
1014         );
1015     }
1016 
1017     /**
1018      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1019      * on the return value: the return value is optional (but if data is returned, it must not be false).
1020      * @param token The token targeted by the call.
1021      * @param data The call data (encoded using abi.encode or one of its variants).
1022      */
1023     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1024         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1025         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1026         // the target address contains contract code and also asserts for success in the low-level call.
1027 
1028         bytes memory returndata = address(token).functionCall(
1029             data,
1030             "SafeERC20: low-level call failed"
1031         );
1032         if (returndata.length > 0) {
1033             // Return data is optional
1034             // solhint-disable-next-line max-line-length
1035             require(
1036                 abi.decode(returndata, (bool)),
1037                 "SafeERC20: ERC20 operation did not succeed"
1038             );
1039         }
1040     }
1041 }
1042 
1043 contract YUANToken is YUANGovernanceToken {
1044     // Modifiers
1045     modifier onlyGov() {
1046         require(msg.sender == gov);
1047         _;
1048     }
1049 
1050     modifier onlyRebaser() {
1051         require(msg.sender == rebaser);
1052         _;
1053     }
1054 
1055     modifier onlyMinter() {
1056         require(
1057             msg.sender == rebaser ||
1058                 msg.sender == gov ||
1059                 msg.sender == incentivizer ||
1060                 msg.sender == migrator,
1061             "not minter"
1062         );
1063         _;
1064     }
1065 
1066     modifier validRecipient(address to) {
1067         require(to != address(0x0));
1068         require(to != address(this));
1069         _;
1070     }
1071 
1072     function initialize(
1073         string memory name_,
1074         string memory symbol_,
1075         uint8 decimals_
1076     ) public {
1077         require(yuansScalingFactor == 0, "already initialized");
1078         name = name_;
1079         symbol = symbol_;
1080         decimals = decimals_;
1081     }
1082 
1083     /**
1084      * @notice Computes the current max scaling factor
1085      */
1086     function maxScalingFactor() external view returns (uint256) {
1087         return _maxScalingFactor();
1088     }
1089 
1090     function _maxScalingFactor() internal view returns (uint256) {
1091         // scaling factor can only go up to 2**256-1 = initSupply * yuansScalingFactor
1092         // this is used to check if yuansScalingFactor will be too high to compute balances when rebasing.
1093         return uint256(-1) / initSupply;
1094     }
1095 
1096     /**
1097      * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
1098      * @dev Limited to onlyMinter modifier
1099      */
1100     function mint(address to, uint256 amount)
1101         external
1102         onlyMinter
1103         returns (bool)
1104     {
1105         _mint(to, amount);
1106         return true;
1107     }
1108 
1109     function _mint(address to, uint256 amount) internal {
1110         if (msg.sender == migrator) {
1111             // migrator directly uses v2 balance for the amount
1112 
1113             // increase initSupply
1114             initSupply = initSupply.add(amount);
1115 
1116             // get external value
1117             uint256 scaledAmount = _yuanToFragment(amount);
1118 
1119             // increase totalSupply
1120             totalSupply = totalSupply.add(scaledAmount);
1121 
1122             // make sure the mint didnt push maxScalingFactor too low
1123             require(
1124                 yuansScalingFactor <= _maxScalingFactor(),
1125                 "max scaling factor too low"
1126             );
1127 
1128             // add balance
1129             _yuanBalances[to] = _yuanBalances[to].add(amount);
1130 
1131             // add delegates to the minter
1132             _moveDelegates(address(0), _delegates[to], amount);
1133             emit Mint(to, scaledAmount);
1134             emit Transfer(address(0), to, scaledAmount);
1135         } else {
1136             // increase totalSupply
1137             totalSupply = totalSupply.add(amount);
1138 
1139             // get underlying value
1140             uint256 yuanValue = _fragmentToYuan(amount);
1141 
1142             // increase initSupply
1143             initSupply = initSupply.add(yuanValue);
1144 
1145             // make sure the mint didnt push maxScalingFactor too low
1146             require(
1147                 yuansScalingFactor <= _maxScalingFactor(),
1148                 "max scaling factor too low"
1149             );
1150 
1151             // add balance
1152             _yuanBalances[to] = _yuanBalances[to].add(yuanValue);
1153 
1154             // add delegates to the minter
1155             _moveDelegates(address(0), _delegates[to], yuanValue);
1156             emit Mint(to, amount);
1157             emit Transfer(address(0), to, amount);
1158         }
1159     }
1160 
1161     /* - ERC20 functionality - */
1162 
1163     /**
1164      * @dev Transfer tokens to a specified address.
1165      * @param to The address to transfer to.
1166      * @param value The amount to be transferred.
1167      * @return True on success, false otherwise.
1168      */
1169     function transfer(address to, uint256 value)
1170         external
1171         validRecipient(to)
1172         returns (bool)
1173     {
1174         // underlying balance is stored in yuans, so divide by current scaling factor
1175 
1176         // note, this means as scaling factor grows, dust will be untransferrable.
1177         // minimum transfer value == yuansScalingFactor / 1e24;
1178 
1179         // get amount in underlying
1180         uint256 yuanValue = _fragmentToYuan(value);
1181 
1182         // sub from balance of sender
1183         _yuanBalances[msg.sender] = _yuanBalances[msg.sender].sub(yuanValue);
1184 
1185         // add to balance of receiver
1186         _yuanBalances[to] = _yuanBalances[to].add(yuanValue);
1187         emit Transfer(msg.sender, to, value);
1188 
1189         _moveDelegates(_delegates[msg.sender], _delegates[to], yuanValue);
1190         return true;
1191     }
1192 
1193     /**
1194      * @dev Transfer tokens from one address to another.
1195      * @param from The address you want to send tokens from.
1196      * @param to The address you want to transfer to.
1197      * @param value The amount of tokens to be transferred.
1198      */
1199     function transferFrom(
1200         address from,
1201         address to,
1202         uint256 value
1203     ) external validRecipient(to) returns (bool) {
1204         // decrease allowance
1205         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
1206             .sender]
1207             .sub(value);
1208 
1209         // get value in yuans
1210         uint256 yuanValue = _fragmentToYuan(value);
1211 
1212         // sub from from
1213         _yuanBalances[from] = _yuanBalances[from].sub(yuanValue);
1214         _yuanBalances[to] = _yuanBalances[to].add(yuanValue);
1215         emit Transfer(from, to, value);
1216 
1217         _moveDelegates(_delegates[from], _delegates[to], yuanValue);
1218         return true;
1219     }
1220 
1221     /**
1222      * @param who The address to query.
1223      * @return The balance of the specified address.
1224      */
1225     function balanceOf(address who) external view returns (uint256) {
1226         return _yuanToFragment(_yuanBalances[who]);
1227     }
1228 
1229     /** @notice Currently returns the internal storage amount
1230      * @param who The address to query.
1231      * @return The underlying balance of the specified address.
1232      */
1233     function balanceOfUnderlying(address who) external view returns (uint256) {
1234         return _yuanBalances[who];
1235     }
1236 
1237     /**
1238      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1239      * @param owner_ The address which owns the funds.
1240      * @param spender The address which will spend the funds.
1241      * @return The number of tokens still available for the spender.
1242      */
1243     function allowance(address owner_, address spender)
1244         external
1245         view
1246         returns (uint256)
1247     {
1248         return _allowedFragments[owner_][spender];
1249     }
1250 
1251     /**
1252      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1253      * msg.sender. This method is included for ERC20 compatibility.
1254      * increaseAllowance and decreaseAllowance should be used instead.
1255      * Changing an allowance with this method brings the risk that someone may transfer both
1256      * the old and the new allowance - if they are both greater than zero - if a transfer
1257      * transaction is mined before the later approve() call is mined.
1258      *
1259      * @param spender The address which will spend the funds.
1260      * @param value The amount of tokens to be spent.
1261      */
1262     function approve(address spender, uint256 value) external returns (bool) {
1263         _allowedFragments[msg.sender][spender] = value;
1264         emit Approval(msg.sender, spender, value);
1265         return true;
1266     }
1267 
1268     /**
1269      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1270      * This method should be used instead of approve() to avoid the double approval vulnerability
1271      * described above.
1272      * @param spender The address which will spend the funds.
1273      * @param addedValue The amount of tokens to increase the allowance by.
1274      */
1275     function increaseAllowance(address spender, uint256 addedValue)
1276         external
1277         returns (bool)
1278     {
1279         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
1280             .sender][spender]
1281             .add(addedValue);
1282         emit Approval(
1283             msg.sender,
1284             spender,
1285             _allowedFragments[msg.sender][spender]
1286         );
1287         return true;
1288     }
1289 
1290     /**
1291      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1292      *
1293      * @param spender The address which will spend the funds.
1294      * @param subtractedValue The amount of tokens to decrease the allowance by.
1295      */
1296     function decreaseAllowance(address spender, uint256 subtractedValue)
1297         external
1298         returns (bool)
1299     {
1300         uint256 oldValue = _allowedFragments[msg.sender][spender];
1301         if (subtractedValue >= oldValue) {
1302             _allowedFragments[msg.sender][spender] = 0;
1303         } else {
1304             _allowedFragments[msg.sender][spender] = oldValue.sub(
1305                 subtractedValue
1306             );
1307         }
1308         emit Approval(
1309             msg.sender,
1310             spender,
1311             _allowedFragments[msg.sender][spender]
1312         );
1313         return true;
1314     }
1315 
1316     // --- Approve by signature ---
1317     function permit(
1318         address owner,
1319         address spender,
1320         uint256 value,
1321         uint256 deadline,
1322         uint8 v,
1323         bytes32 r,
1324         bytes32 s
1325     ) external {
1326         require(now <= deadline, "YUAN/permit-expired");
1327 
1328         bytes32 digest = keccak256(
1329             abi.encodePacked(
1330                 "\x19\x01",
1331                 DOMAIN_SEPARATOR,
1332                 keccak256(
1333                     abi.encode(
1334                         PERMIT_TYPEHASH,
1335                         owner,
1336                         spender,
1337                         value,
1338                         nonces[owner]++,
1339                         deadline
1340                     )
1341                 )
1342             )
1343         );
1344 
1345         require(owner != address(0), "YUAN/invalid-address-0");
1346         require(owner == ecrecover(digest, v, r, s), "YUAN/invalid-permit");
1347         _allowedFragments[owner][spender] = value;
1348         emit Approval(owner, spender, value);
1349     }
1350 
1351     /* - Governance Functions - */
1352 
1353     /** @notice sets the rebaser
1354      * @param rebaser_ The address of the rebaser contract to use for authentication.
1355      */
1356     function _setRebaser(address rebaser_) external onlyGov {
1357         address oldRebaser = rebaser;
1358         rebaser = rebaser_;
1359         emit NewRebaser(oldRebaser, rebaser_);
1360     }
1361 
1362     /** @notice sets the migrator
1363      * @param migrator_ The address of the migrator contract to use for authentication.
1364      */
1365     function _setMigrator(address migrator_) external onlyGov {
1366         address oldMigrator = migrator_;
1367         migrator = migrator_;
1368         emit NewMigrator(oldMigrator, migrator_);
1369     }
1370 
1371     /** @notice sets the incentivizer
1372      * @param incentivizer_ The address of the rebaser contract to use for authentication.
1373      */
1374     function _setIncentivizer(address incentivizer_) external onlyGov {
1375         address oldIncentivizer = incentivizer;
1376         incentivizer = incentivizer_;
1377         emit NewIncentivizer(oldIncentivizer, incentivizer_);
1378     }
1379 
1380     /** @notice sets the pendingGov
1381      * @param pendingGov_ The address of the rebaser contract to use for authentication.
1382      */
1383     function _setPendingGov(address pendingGov_) external onlyGov {
1384         address oldPendingGov = pendingGov;
1385         pendingGov = pendingGov_;
1386         emit NewPendingGov(oldPendingGov, pendingGov_);
1387     }
1388 
1389     /** @notice lets msg.sender accept governance
1390      *
1391      */
1392     function _acceptGov() external {
1393         require(msg.sender == pendingGov, "!pending");
1394         address oldGov = gov;
1395         gov = pendingGov;
1396         pendingGov = address(0);
1397         emit NewGov(oldGov, gov);
1398     }
1399 
1400     /* - Extras - */
1401 
1402     /**
1403      * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
1404      *
1405      * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
1406      *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
1407      *      and targetRate is CpiOracleRate / baseCpi
1408      */
1409     function rebase(
1410         uint256 epoch,
1411         uint256 indexDelta,
1412         bool positive
1413     ) external onlyRebaser returns (uint256) {
1414         // no change
1415         if (indexDelta == 0) {
1416             emit Rebase(epoch, yuansScalingFactor, yuansScalingFactor);
1417             return totalSupply;
1418         }
1419 
1420         // for events
1421         uint256 prevYuansScalingFactor = yuansScalingFactor;
1422 
1423         if (!positive) {
1424             // negative rebase, decrease scaling factor
1425             yuansScalingFactor = yuansScalingFactor
1426                 .mul(BASE.sub(indexDelta))
1427                 .div(BASE);
1428         } else {
1429             // positive reabse, increase scaling factor
1430             uint256 newScalingFactor = yuansScalingFactor
1431                 .mul(BASE.add(indexDelta))
1432                 .div(BASE);
1433             if (newScalingFactor < _maxScalingFactor()) {
1434                 yuansScalingFactor = newScalingFactor;
1435             } else {
1436                 yuansScalingFactor = _maxScalingFactor();
1437             }
1438         }
1439 
1440         // update total supply, correctly
1441         totalSupply = _yuanToFragment(initSupply);
1442 
1443         emit Rebase(epoch, prevYuansScalingFactor, yuansScalingFactor);
1444         return totalSupply;
1445     }
1446 
1447     function yuanToFragment(uint256 yuan) external view returns (uint256) {
1448         return _yuanToFragment(yuan);
1449     }
1450 
1451     function fragmentToYuan(uint256 value) external view returns (uint256) {
1452         return _fragmentToYuan(value);
1453     }
1454 
1455     function _yuanToFragment(uint256 yuan) internal view returns (uint256) {
1456         return yuan.mul(yuansScalingFactor).div(internalDecimals);
1457     }
1458 
1459     function _fragmentToYuan(uint256 value) internal view returns (uint256) {
1460         return value.mul(internalDecimals).div(yuansScalingFactor);
1461     }
1462 
1463     // Rescue tokens
1464     function rescueTokens(
1465         address token,
1466         address to,
1467         uint256 amount
1468     ) external onlyGov returns (bool) {
1469         // transfer to
1470         SafeERC20.safeTransfer(IERC20(token), to, amount);
1471         return true;
1472     }
1473 }
1474 
1475 contract YUAN is YUANToken {
1476     /**
1477      * @notice Initialize the new money market
1478      * @param name_ ERC-20 name of this token
1479      * @param symbol_ ERC-20 symbol of this token
1480      * @param decimals_ ERC-20 decimal precision of this token
1481      */
1482     function initialize(
1483         string memory name_,
1484         string memory symbol_,
1485         uint8 decimals_,
1486         address initial_owner,
1487         uint256 initTotalSupply_
1488     ) public {
1489         super.initialize(name_, symbol_, decimals_);
1490 
1491         yuansScalingFactor = BASE;
1492         initSupply = _fragmentToYuan(initTotalSupply_);
1493         totalSupply = initTotalSupply_;
1494         _yuanBalances[initial_owner] = initSupply;
1495 
1496         DOMAIN_SEPARATOR = keccak256(
1497             abi.encode(
1498                 DOMAIN_TYPEHASH,
1499                 keccak256(bytes(name)),
1500                 getChainId(),
1501                 address(this)
1502             )
1503         );
1504     }
1505 }
1506 
1507 contract YUANDelegationStorage {
1508     /**
1509      * @notice Implementation address for this contract
1510      */
1511     address public implementation;
1512 }
1513 
1514 contract YUANDelegatorInterface is YUANDelegationStorage {
1515     /**
1516      * @notice Emitted when implementation is changed
1517      */
1518     event NewImplementation(
1519         address oldImplementation,
1520         address newImplementation
1521     );
1522 
1523     /**
1524      * @notice Called by the gov to update the implementation of the delegator
1525      * @param implementation_ The address of the new implementation for delegation
1526      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1527      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1528      */
1529     function _setImplementation(
1530         address implementation_,
1531         bool allowResign,
1532         bytes memory becomeImplementationData
1533     ) public;
1534 }
1535 
1536 contract YUANDelegateInterface is YUANDelegationStorage {
1537     /**
1538      * @notice Called by the delegator on a delegate to initialize it for duty
1539      * @dev Should revert if any issues arise which make it unfit for delegation
1540      * @param data The encoded bytes data for any initialization
1541      */
1542     function _becomeImplementation(bytes memory data) public;
1543 
1544     /**
1545      * @notice Called by the delegator on a delegate to forfeit its responsibility
1546      */
1547     function _resignImplementation() public;
1548 }
1549 
1550 contract YUANDelegate is YUAN, YUANDelegateInterface {
1551     /**
1552      * @notice Construct an empty delegate
1553      */
1554     constructor() public {}
1555 
1556     /**
1557      * @notice Called by the delegator on a delegate to initialize it for duty
1558      * @param data The encoded bytes data for any initialization
1559      */
1560     function _becomeImplementation(bytes memory data) public {
1561         // Shh -- currently unused
1562         data;
1563 
1564         // Shh -- we don't ever want this hook to be marked pure
1565         if (false) {
1566             implementation = address(0);
1567         }
1568 
1569         require(
1570             msg.sender == gov,
1571             "only the gov may call _becomeImplementation"
1572         );
1573     }
1574 
1575     /**
1576      * @notice Called by the delegator on a delegate to forfeit its responsibility
1577      */
1578     function _resignImplementation() public {
1579         // Shh -- we don't ever want this hook to be marked pure
1580         if (false) {
1581             implementation = address(0);
1582         }
1583 
1584         require(
1585             msg.sender == gov,
1586             "only the gov may call _resignImplementation"
1587         );
1588     }
1589 }
1590 
1591 contract YUANDelegator is YUANTokenInterface, YUANDelegatorInterface {
1592     /**
1593      * @notice Construct a new YUAN
1594      * @param name_ ERC-20 name of this token
1595      * @param symbol_ ERC-20 symbol of this token
1596      * @param decimals_ ERC-20 decimal precision of this token
1597      * @param initTotalSupply_ Initial token amount
1598      * @param implementation_ The address of the implementation the contract delegates to
1599      * @param becomeImplementationData The encoded args for becomeImplementation
1600      */
1601     constructor(
1602         string memory name_,
1603         string memory symbol_,
1604         uint8 decimals_,
1605         uint256 initTotalSupply_,
1606         address implementation_,
1607         bytes memory becomeImplementationData
1608     ) public {
1609         // Creator of the contract is gov during initialization
1610         gov = msg.sender;
1611 
1612         // First delegate gets to initialize the delegator (i.e. storage contract)
1613         delegateTo(
1614             implementation_,
1615             abi.encodeWithSignature(
1616                 "initialize(string,string,uint8,address,uint256)",
1617                 name_,
1618                 symbol_,
1619                 decimals_,
1620                 msg.sender,
1621                 initTotalSupply_
1622             )
1623         );
1624 
1625         // New implementations always get set via the settor (post-initialize)
1626         _setImplementation(implementation_, false, becomeImplementationData);
1627     }
1628 
1629     /**
1630      * @notice Called by the gov to update the implementation of the delegator
1631      * @param implementation_ The address of the new implementation for delegation
1632      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1633      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1634      */
1635     function _setImplementation(
1636         address implementation_,
1637         bool allowResign,
1638         bytes memory becomeImplementationData
1639     ) public {
1640         require(
1641             msg.sender == gov,
1642             "YUANDelegator::_setImplementation: Caller must be gov"
1643         );
1644 
1645         if (allowResign) {
1646             delegateToImplementation(
1647                 abi.encodeWithSignature("_resignImplementation()")
1648             );
1649         }
1650 
1651         address oldImplementation = implementation;
1652         implementation = implementation_;
1653 
1654         delegateToImplementation(
1655             abi.encodeWithSignature(
1656                 "_becomeImplementation(bytes)",
1657                 becomeImplementationData
1658             )
1659         );
1660 
1661         emit NewImplementation(oldImplementation, implementation);
1662     }
1663 
1664     /**
1665      * @notice Sender supplies assets into the market and receives cTokens in exchange
1666      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1667      * @param mintAmount The amount of the underlying asset to supply
1668      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1669      */
1670     function mint(address to, uint256 mintAmount) external returns (bool) {
1671         to;
1672         mintAmount; // Shh
1673         delegateAndReturn();
1674     }
1675 
1676     /**
1677      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1678      * @param dst The address of the destination account
1679      * @param amount The number of tokens to transfer
1680      * @return Whether or not the transfer succeeded
1681      */
1682     function transfer(address dst, uint256 amount) external returns (bool) {
1683         dst;
1684         amount; // Shh
1685         delegateAndReturn();
1686     }
1687 
1688     /**
1689      * @notice Transfer `amount` tokens from `src` to `dst`
1690      * @param src The address of the source account
1691      * @param dst The address of the destination account
1692      * @param amount The number of tokens to transfer
1693      * @return Whether or not the transfer succeeded
1694      */
1695     function transferFrom(
1696         address src,
1697         address dst,
1698         uint256 amount
1699     ) external returns (bool) {
1700         src;
1701         dst;
1702         amount; // Shh
1703         delegateAndReturn();
1704     }
1705 
1706     /**
1707      * @notice Approve `spender` to transfer up to `amount` from `src`
1708      * @dev This will overwrite the approval amount for `spender`
1709      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1710      * @param spender The address of the account which may transfer tokens
1711      * @param amount The number of tokens that are approved (-1 means infinite)
1712      * @return Whether or not the approval succeeded
1713      */
1714     function approve(address spender, uint256 amount) external returns (bool) {
1715         spender;
1716         amount; // Shh
1717         delegateAndReturn();
1718     }
1719 
1720     /**
1721      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1722      * This method should be used instead of approve() to avoid the double approval vulnerability
1723      * described above.
1724      * @param spender The address which will spend the funds.
1725      * @param addedValue The amount of tokens to increase the allowance by.
1726      */
1727     function increaseAllowance(address spender, uint256 addedValue)
1728         external
1729         returns (bool)
1730     {
1731         spender;
1732         addedValue; // Shh
1733         delegateAndReturn();
1734     }
1735 
1736     function maxScalingFactor() external view returns (uint256) {
1737         delegateToViewAndReturn();
1738     }
1739 
1740     function rebase(
1741         uint256 epoch,
1742         uint256 indexDelta,
1743         bool positive
1744     ) external returns (uint256) {
1745         epoch;
1746         indexDelta;
1747         positive;
1748         delegateAndReturn();
1749     }
1750 
1751     /**
1752      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1753      *
1754      * @param spender The address which will spend the funds.
1755      * @param subtractedValue The amount of tokens to decrease the allowance by.
1756      */
1757     function decreaseAllowance(address spender, uint256 subtractedValue)
1758         external
1759         returns (bool)
1760     {
1761         spender;
1762         subtractedValue; // Shh
1763         delegateAndReturn();
1764     }
1765 
1766     // --- Approve by signature ---
1767     function permit(
1768         address owner,
1769         address spender,
1770         uint256 value,
1771         uint256 deadline,
1772         uint8 v,
1773         bytes32 r,
1774         bytes32 s
1775     ) external {
1776         owner;
1777         spender;
1778         value;
1779         deadline;
1780         v;
1781         r;
1782         s; // Shh
1783         delegateAndReturn();
1784     }
1785 
1786     /**
1787      * @notice Get the current allowance from `owner` for `spender`
1788      * @param owner The address of the account which owns the tokens to be spent
1789      * @param spender The address of the account which may transfer tokens
1790      * @return The number of tokens allowed to be spent (-1 means infinite)
1791      */
1792     function allowance(address owner, address spender)
1793         external
1794         view
1795         returns (uint256)
1796     {
1797         owner;
1798         spender; // Shh
1799         delegateToViewAndReturn();
1800     }
1801 
1802     /**
1803      * @notice Rescues tokens and sends them to the `to` address
1804      * @param token The address of the token
1805      * @param to The address for which the tokens should be send
1806      * @return Success
1807      */
1808     function rescueTokens(
1809         address token,
1810         address to,
1811         uint256 amount
1812     ) external returns (bool) {
1813         token;
1814         to;
1815         amount; // Shh
1816         delegateAndReturn();
1817     }
1818 
1819     /**
1820      * @notice Get the current allowance from `owner` for `spender`
1821      * @param delegator The address of the account which has designated a delegate
1822      * @return Address of delegatee
1823      */
1824     function delegates(address delegator) external view returns (address) {
1825         delegator; // Shh
1826         delegateToViewAndReturn();
1827     }
1828 
1829     /**
1830      * @notice Get the token balance of the `owner`
1831      * @param owner The address of the account to query
1832      * @return The number of tokens owned by `owner`
1833      */
1834     function balanceOf(address owner) external view returns (uint256) {
1835         owner; // Shh
1836         delegateToViewAndReturn();
1837     }
1838 
1839     /**
1840      * @notice Currently unused. For future compatability
1841      * @param owner The address of the account to query
1842      * @return The number of underlying tokens owned by `owner`
1843      */
1844     function balanceOfUnderlying(address owner)
1845         external
1846         view
1847         returns (uint256)
1848     {
1849         owner; // Shh
1850         delegateToViewAndReturn();
1851     }
1852 
1853     /*** Gov Functions ***/
1854 
1855     /**
1856      * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
1857      * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
1858      * @param newPendingGov New pending gov.
1859      */
1860     function _setPendingGov(address newPendingGov) external {
1861         newPendingGov; // Shh
1862         delegateAndReturn();
1863     }
1864 
1865     function _setRebaser(address rebaser_) external {
1866         rebaser_; // Shh
1867         delegateAndReturn();
1868     }
1869 
1870     function _setIncentivizer(address incentivizer_) external {
1871         incentivizer_; // Shh
1872         delegateAndReturn();
1873     }
1874 
1875     function _setMigrator(address migrator_) external {
1876         migrator_; // Shh
1877         delegateAndReturn();
1878     }
1879 
1880     /**
1881      * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
1882      * @dev Gov function for pending gov to accept role and update gov
1883      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1884      */
1885     function _acceptGov() external {
1886         delegateAndReturn();
1887     }
1888 
1889     function getPriorVotes(address account, uint256 blockNumber)
1890         external
1891         view
1892         returns (uint256)
1893     {
1894         account;
1895         blockNumber;
1896         delegateToViewAndReturn();
1897     }
1898 
1899     function delegateBySig(
1900         address delegatee,
1901         uint256 nonce,
1902         uint256 expiry,
1903         uint8 v,
1904         bytes32 r,
1905         bytes32 s
1906     ) external {
1907         delegatee;
1908         nonce;
1909         expiry;
1910         v;
1911         r;
1912         s;
1913         delegateAndReturn();
1914     }
1915 
1916     function delegate(address delegatee) external {
1917         delegatee;
1918         delegateAndReturn();
1919     }
1920 
1921     function getCurrentVotes(address account) external view returns (uint256) {
1922         account;
1923         delegateToViewAndReturn();
1924     }
1925 
1926     function yuanToFragment(uint256 yuan) external view returns (uint256) {
1927         yuan;
1928         delegateToViewAndReturn();
1929     }
1930 
1931     function fragmentToYuan(uint256 value) external view returns (uint256) {
1932         value;
1933         delegateToViewAndReturn();
1934     }
1935 
1936     /**
1937      * @notice Internal method to delegate execution to another contract
1938      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1939      * @param callee The contract to delegatecall
1940      * @param data The raw data to delegatecall
1941      * @return The returned bytes from the delegatecall
1942      */
1943     function delegateTo(address callee, bytes memory data)
1944         internal
1945         returns (bytes memory)
1946     {
1947         (bool success, bytes memory returnData) = callee.delegatecall(data);
1948         assembly {
1949             if eq(success, 0) {
1950                 revert(add(returnData, 0x20), returndatasize)
1951             }
1952         }
1953         return returnData;
1954     }
1955 
1956     /**
1957      * @notice Delegates execution to the implementation contract
1958      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1959      * @param data The raw data to delegatecall
1960      * @return The returned bytes from the delegatecall
1961      */
1962     function delegateToImplementation(bytes memory data)
1963         public
1964         returns (bytes memory)
1965     {
1966         return delegateTo(implementation, data);
1967     }
1968 
1969     /**
1970      * @notice Delegates execution to an implementation contract
1971      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1972      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1973      * @param data The raw data to delegatecall
1974      * @return The returned bytes from the delegatecall
1975      */
1976     function delegateToViewImplementation(bytes memory data)
1977         public
1978         view
1979         returns (bytes memory)
1980     {
1981         (bool success, bytes memory returnData) = address(this).staticcall(
1982             abi.encodeWithSignature("delegateToImplementation(bytes)", data)
1983         );
1984         assembly {
1985             if eq(success, 0) {
1986                 revert(add(returnData, 0x20), returndatasize)
1987             }
1988         }
1989         return abi.decode(returnData, (bytes));
1990     }
1991 
1992     function delegateToViewAndReturn() private view returns (bytes memory) {
1993         (bool success, ) = address(this).staticcall(
1994             abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data)
1995         );
1996 
1997         assembly {
1998             let free_mem_ptr := mload(0x40)
1999             returndatacopy(free_mem_ptr, 0, returndatasize)
2000 
2001             switch success
2002                 case 0 {
2003                     revert(free_mem_ptr, returndatasize)
2004                 }
2005                 default {
2006                     return(add(free_mem_ptr, 0x40), sub(returndatasize, 0x40))
2007                 }
2008         }
2009     }
2010 
2011     function delegateAndReturn() private returns (bytes memory) {
2012         (bool success, ) = implementation.delegatecall(msg.data);
2013 
2014         assembly {
2015             let free_mem_ptr := mload(0x40)
2016             returndatacopy(free_mem_ptr, 0, returndatasize)
2017 
2018             switch success
2019                 case 0 {
2020                     revert(free_mem_ptr, returndatasize)
2021                 }
2022                 default {
2023                     return(free_mem_ptr, returndatasize)
2024                 }
2025         }
2026     }
2027 
2028     /**
2029      * @notice Delegates execution to an implementation contract
2030      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
2031      */
2032     function() external payable {
2033         require(
2034             msg.value == 0,
2035             "YUANDelegator:fallback: cannot send value to fallback"
2036         );
2037 
2038         // delegate all other functions to current implementation
2039         delegateAndReturn();
2040     }
2041 }