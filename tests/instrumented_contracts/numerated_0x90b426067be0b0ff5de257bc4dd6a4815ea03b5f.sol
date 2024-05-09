1 // File: contracts/lib/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.5.15;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/token/STRNTokenStorage.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity 0.5.15;
168 
169 
170 // Storage for a STRN token
171 contract STRNTokenStorage {
172 
173     using SafeMath for uint256;
174 
175     /**
176      * @dev Guard variable for re-entrancy checks. Not currently used
177      */
178     bool internal _notEntered;
179 
180     /**
181      * @notice EIP-20 token name for this token
182      */
183     string public name;
184 
185     /**
186      * @notice EIP-20 token symbol for this token
187      */
188     string public symbol;
189 
190     /**
191      * @notice EIP-20 token decimals for this token
192      */
193     uint8 public decimals;
194 
195     /**
196      * @notice Governor for this contract
197      */
198     address public gov;
199 
200     /**
201      * @notice Pending governance for this contract
202      */
203     address public pendingGov;
204 
205     /**
206      * @notice Incentivizer address of STRN protocol
207      */
208     address public incentivizer;
209 
210     /**
211      * @notice Total supply of STRNs
212      */
213     uint256 public totalSupply;
214 
215     /**
216      * @notice Max supply of STRNs
217      */
218     uint256 public maxSupply;
219 
220     /**
221      * @notice Internal decimals used to handle scaling factor
222      */
223     uint256 public constant internalDecimals = 10**24;
224 
225     /**
226      * @notice Used for percentage maths
227      */
228     uint256 public constant BASE = 10**18;
229 
230     mapping (address => uint256) internal _strnBalances;
231 
232     mapping (address => mapping (address => uint256)) internal _allowedFragments;
233 
234     uint256 public initSupply;
235 
236 
237     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
238     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
239     bytes32 public DOMAIN_SEPARATOR;
240 }
241 
242 // File: contracts/token/STRNGovernanceStorage.sol
243 
244 pragma solidity 0.5.15;
245 pragma experimental ABIEncoderV2;
246 
247 /* Copyright 2020 Compound Labs, Inc.
248 
249 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
250 
251 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
252 
253 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
254 
255 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
256 
257 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
258 
259 
260 contract STRNGovernanceStorage {
261     /// @notice A record of each accounts delegate
262     mapping (address => address) internal _delegates;
263 
264     /// @notice A checkpoint for marking number of votes from a given block
265     struct Checkpoint {
266         uint32 fromBlock;
267         uint256 votes;
268     }
269 
270     /// @notice A record of votes checkpoints for each account, by index
271     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
272 
273     /// @notice The number of checkpoints for each account
274     mapping (address => uint32) public numCheckpoints;
275 
276     /// @notice The EIP-712 typehash for the contract's domain
277     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
278 
279     /// @notice The EIP-712 typehash for the delegation struct used by the contract
280     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
281 
282     /// @notice A record of states for signing / validating signatures
283     mapping (address => uint) public nonces;
284 }
285 
286 // File: contracts/token/STRNTokenInterface.sol
287 
288 // SPDX-License-Identifier: MIT
289 
290 pragma solidity 0.5.15;
291 
292 contract STRNTokenInterface is STRNTokenStorage, STRNGovernanceStorage {
293 
294     /// @notice An event thats emitted when an account changes its delegate
295     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
296 
297     /// @notice An event thats emitted when a delegate account's vote balance changes
298     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
299 
300     /*** Gov Events ***/
301 
302     /**
303      * @notice Event emitted when pendingGov is changed
304      */
305     event NewPendingGov(address oldPendingGov, address newPendingGov);
306 
307     /**
308      * @notice Event emitted when gov is changed
309      */
310     event NewGov(address oldGov, address newGov);
311 
312     /**
313      * @notice Sets the incentivizer contract
314      */
315     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
316 
317     /* - ERC20 Events - */
318 
319     /**
320      * @notice EIP20 Transfer event
321      */
322     event Transfer(address indexed from, address indexed to, uint amount);
323 
324     /**
325      * @notice EIP20 Approval event
326      */
327     event Approval(address indexed owner, address indexed spender, uint amount);
328 
329     /* - Extra Events - */
330     /**
331      * @notice Tokens minted event
332      */
333     event Mint(address to, uint256 amount);
334 
335     // Public functions
336     function transfer(address to, uint256 value) external returns(bool);
337     function transferFrom(address from, address to, uint256 value) external returns(bool);
338     function balanceOf(address who) external view returns(uint256);
339     function allowance(address owner_, address spender) external view returns(uint256);
340     function approve(address spender, uint256 value) external returns (bool);
341     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
342     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
343 
344     /* - Governance Functions - */
345     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
346     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
347     function delegate(address delegatee) external;
348     function delegates(address delegator) external view returns (address);
349     function getCurrentVotes(address account) external view returns (uint256);
350 
351     /* - Permissioned/Governance functions - */
352     function mint(address to, uint256 amount) external returns (bool);
353     function _setIncentivizer(address incentivizer_) external;
354     function _setPendingGov(address pendingGov_) external;
355     function _acceptGov() external;
356 }
357 
358 // File: contracts/token/STRNGovernance.sol
359 
360 pragma solidity 0.5.15;
361 
362 /* Copyright 2020 Compound Labs, Inc.
363 
364 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
365 
366 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
367 
368 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
369 
370 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
371 
372 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
373 
374 
375 
376 contract STRNGovernanceToken is STRNTokenInterface {
377 
378       /// @notice An event thats emitted when an account changes its delegate
379     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
380 
381     /// @notice An event thats emitted when a delegate account's vote balance changes
382     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
383 
384     /**
385      * @notice Get delegatee for an address delegating
386      * @param delegator The address to get delegatee for
387      */
388     function delegates(address delegator)
389         external
390         view
391         returns (address)
392     {
393         return _delegates[delegator];
394     }
395 
396    /**
397     * @notice Delegate votes from `msg.sender` to `delegatee`
398     * @param delegatee The address to delegate votes to
399     */
400     function delegate(address delegatee) external {
401         return _delegate(msg.sender, delegatee);
402     }
403 
404     /**
405      * @notice Delegates votes from signatory to `delegatee`
406      * @param delegatee The address to delegate votes to
407      * @param nonce The contract state required to match the signature
408      * @param expiry The time at which to expire the signature
409      * @param v The recovery byte of the signature
410      * @param r Half of the ECDSA signature pair
411      * @param s Half of the ECDSA signature pair
412      */
413     function delegateBySig(
414         address delegatee,
415         uint nonce,
416         uint expiry,
417         uint8 v,
418         bytes32 r,
419         bytes32 s
420     )
421         external
422     {
423         bytes32 structHash = keccak256(
424             abi.encode(
425                 DELEGATION_TYPEHASH,
426                 delegatee,
427                 nonce,
428                 expiry
429             )
430         );
431 
432         bytes32 digest = keccak256(
433             abi.encodePacked(
434                 "\x19\x01",
435                 DOMAIN_SEPARATOR,
436                 structHash
437             )
438         );
439 
440         address signatory = ecrecover(digest, v, r, s);
441         require(signatory != address(0), "STRN::delegateBySig: invalid signature");
442         require(nonce == nonces[signatory]++, "STRN::delegateBySig: invalid nonce");
443         require(now <= expiry, "STRN::delegateBySig: signature expired");
444         return _delegate(signatory, delegatee);
445     }
446 
447     /**
448      * @notice Gets the current votes balance for `account`
449      * @param account The address to get votes balance
450      * @return The number of current votes for `account`
451      */
452     function getCurrentVotes(address account)
453         external
454         view
455         returns (uint256)
456     {
457         uint32 nCheckpoints = numCheckpoints[account];
458         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
459     }
460 
461     /**
462      * @notice Determine the prior number of votes for an account as of a block number
463      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
464      * @param account The address of the account to check
465      * @param blockNumber The block number to get the vote balance at
466      * @return The number of votes the account had as of the given block
467      */
468     function getPriorVotes(address account, uint blockNumber)
469         external
470         view
471         returns (uint256)
472     {
473         require(blockNumber < block.number, "STRN::getPriorVotes: not yet determined");
474 
475         uint32 nCheckpoints = numCheckpoints[account];
476         if (nCheckpoints == 0) {
477             return 0;
478         }
479 
480         // First check most recent balance
481         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
482             return checkpoints[account][nCheckpoints - 1].votes;
483         }
484 
485         // Next check implicit zero balance
486         if (checkpoints[account][0].fromBlock > blockNumber) {
487             return 0;
488         }
489 
490         uint32 lower = 0;
491         uint32 upper = nCheckpoints - 1;
492         while (upper > lower) {
493             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
494             Checkpoint memory cp = checkpoints[account][center];
495             if (cp.fromBlock == blockNumber) {
496                 return cp.votes;
497             } else if (cp.fromBlock < blockNumber) {
498                 lower = center;
499             } else {
500                 upper = center - 1;
501             }
502         }
503         return checkpoints[account][lower].votes;
504     }
505 
506     function _delegate(address delegator, address delegatee)
507         internal
508     {
509         address currentDelegate = _delegates[delegator];
510         uint256 delegatorBalance = _strnBalances[delegator]; // balance of underlying STRNs (not scaled);
511         _delegates[delegator] = delegatee;
512 
513         emit DelegateChanged(delegator, currentDelegate, delegatee);
514 
515         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
516     }
517 
518     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
519         if (srcRep != dstRep && amount > 0) {
520             if (srcRep != address(0)) {
521                 // decrease old representative
522                 uint32 srcRepNum = numCheckpoints[srcRep];
523                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
524                 uint256 srcRepNew = srcRepOld.sub(amount);
525                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
526             }
527 
528             if (dstRep != address(0)) {
529                 // increase new representative
530                 uint32 dstRepNum = numCheckpoints[dstRep];
531                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
532                 uint256 dstRepNew = dstRepOld.add(amount);
533                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
534             }
535         }
536     }
537 
538     function _writeCheckpoint(
539         address delegatee,
540         uint32 nCheckpoints,
541         uint256 oldVotes,
542         uint256 newVotes
543     )
544         internal
545     {
546         uint32 blockNumber = safe32(block.number, "STRN::_writeCheckpoint: block number exceeds 32 bits");
547 
548         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
549             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
550         } else {
551             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
552             numCheckpoints[delegatee] = nCheckpoints + 1;
553         }
554 
555         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
556     }
557 
558     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
559         require(n < 2**32, errorMessage);
560         return uint32(n);
561     }
562 
563     function getChainId() internal pure returns (uint) {
564         uint256 chainId;
565         assembly { chainId := chainid() }
566         return chainId;
567     }
568 }
569 
570 // File: contracts/lib/IERC20.sol
571 
572 // SPDX-License-Identifier: MIT
573 
574 pragma solidity ^0.5.15;
575 
576 /**
577  * @dev Interface of the ERC20 standard as defined in the EIP.
578  */
579 interface IERC20 {
580     /**
581      * @dev Returns the amount of tokens in existence.
582      */
583     function totalSupply() external view returns (uint256);
584 
585     /**
586      * @dev Returns the amount of tokens owned by `account`.
587      */
588     function balanceOf(address account) external view returns (uint256);
589 
590     /**
591      * @dev Moves `amount` tokens from the caller's account to `recipient`.
592      *
593      * Returns a boolean value indicating whether the operation succeeded.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transfer(address recipient, uint256 amount) external returns (bool);
598 
599     /**
600      * @dev Returns the remaining number of tokens that `spender` will be
601      * allowed to spend on behalf of `owner` through {transferFrom}. This is
602      * zero by default.
603      *
604      * This value changes when {approve} or {transferFrom} are called.
605      */
606     function allowance(address owner, address spender) external view returns (uint256);
607 
608     /**
609      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
610      *
611      * Returns a boolean value indicating whether the operation succeeded.
612      *
613      * IMPORTANT: Beware that changing an allowance with this method brings the risk
614      * that someone may use both the old and the new allowance by unfortunate
615      * transaction ordering. One possible solution to mitigate this race
616      * condition is to first reduce the spender's allowance to 0 and set the
617      * desired value afterwards:
618      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
619      *
620      * Emits an {Approval} event.
621      */
622     function approve(address spender, uint256 amount) external returns (bool);
623 
624     /**
625      * @dev Moves `amount` tokens from `sender` to `recipient` using the
626      * allowance mechanism. `amount` is then deducted from the caller's
627      * allowance.
628      *
629      * Returns a boolean value indicating whether the operation succeeded.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
634 
635     /**
636      * @dev Emitted when `value` tokens are moved from one account (`from`) to
637      * another (`to`).
638      *
639      * Note that `value` may be zero.
640      */
641     event Transfer(address indexed from, address indexed to, uint256 value);
642 
643     /**
644      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
645      * a call to {approve}. `value` is the new allowance.
646      */
647     event Approval(address indexed owner, address indexed spender, uint256 value);
648 }
649 
650 // File: contracts/lib/Address.sol
651 
652 // SPDX-License-Identifier: MIT
653 
654 pragma solidity ^0.5.15;
655 
656 /**
657  * @dev Collection of functions related to the address type
658  */
659 library Address {
660     /**
661      * @dev Returns true if `account` is a contract.
662      *
663      * [IMPORTANT]
664      * ====
665      * It is unsafe to assume that an address for which this function returns
666      * false is an externally-owned account (EOA) and not a contract.
667      *
668      * Among others, `isContract` will return false for the following
669      * types of addresses:
670      *
671      *  - an externally-owned account
672      *  - a contract in construction
673      *  - an address where a contract will be created
674      *  - an address where a contract lived, but was destroyed
675      * ====
676      */
677     function isContract(address account) internal view returns (bool) {
678         // This method relies in extcodesize, which returns 0 for contracts in
679         // construction, since the code is only stored at the end of the
680         // constructor execution.
681 
682         uint256 size;
683         // solhint-disable-next-line no-inline-assembly
684         assembly { size := extcodesize(account) }
685         return size > 0;
686     }
687 
688     /**
689      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
690      * `recipient`, forwarding all available gas and reverting on errors.
691      *
692      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
693      * of certain opcodes, possibly making contracts go over the 2300 gas limit
694      * imposed by `transfer`, making them unable to receive funds via
695      * `transfer`. {sendValue} removes this limitation.
696      *
697      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
698      *
699      * IMPORTANT: because control is transferred to `recipient`, care must be
700      * taken to not create reentrancy vulnerabilities. Consider using
701      * {ReentrancyGuard} or the
702      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
703      */
704     function sendValue(address payable recipient, uint256 amount) internal {
705         require(address(this).balance >= amount, "Address: insufficient balance");
706 
707         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
708         (bool success, ) = recipient.call.value(amount)("");
709         require(success, "Address: unable to send value, recipient may have reverted");
710     }
711 
712     /**
713      * @dev Performs a Solidity function call using a low level `call`. A
714      * plain`call` is an unsafe replacement for a function call: use this
715      * function instead.
716      *
717      * If `target` reverts with a revert reason, it is bubbled up by this
718      * function (like regular Solidity function calls).
719      *
720      * Returns the raw returned data. To convert to the expected return value,
721      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
722      *
723      * Requirements:
724      *
725      * - `target` must be a contract.
726      * - calling `target` with `data` must not revert.
727      *
728      * _Available since v3.1._
729      */
730     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
731       return functionCall(target, data, "Address: low-level call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
736      * `errorMessage` as a fallback revert reason when `target` reverts.
737      *
738      * _Available since v3.1._
739      */
740     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
741         return _functionCallWithValue(target, data, 0, errorMessage);
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
746      * but also transferring `value` wei to `target`.
747      *
748      * Requirements:
749      *
750      * - the calling contract must have an ETH balance of at least `value`.
751      * - the called Solidity function must be `payable`.
752      *
753      * _Available since v3.1._
754      */
755     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
756         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
761      * with `errorMessage` as a fallback revert reason when `target` reverts.
762      *
763      * _Available since v3.1._
764      */
765     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
766         require(address(this).balance >= value, "Address: insufficient balance for call");
767         return _functionCallWithValue(target, data, value, errorMessage);
768     }
769 
770     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
771         require(isContract(target), "Address: call to non-contract");
772 
773         // solhint-disable-next-line avoid-low-level-calls
774         (bool success, bytes memory returndata) = target.call.value(weiValue)(data);
775         if (success) {
776             return returndata;
777         } else {
778             // Look for revert reason and bubble it up if present
779             if (returndata.length > 0) {
780                 // The easiest way to bubble the revert reason is using memory via assembly
781 
782                 // solhint-disable-next-line no-inline-assembly
783                 assembly {
784                     let returndata_size := mload(returndata)
785                     revert(add(32, returndata), returndata_size)
786                 }
787             } else {
788                 revert(errorMessage);
789             }
790         }
791     }
792 }
793 
794 // File: contracts/lib/SafeERC20.sol
795 
796 // SPDX-License-Identifier: MIT
797 
798 pragma solidity ^0.5.15;
799 
800 
801 
802 
803 /**
804  * @title SafeERC20
805  * @dev Wrappers around ERC20 operations that throw on failure (when the token
806  * contract returns false). Tokens that return no value (and instead revert or
807  * throw on failure) are also supported, non-reverting calls are assumed to be
808  * successful.
809  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
810  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
811  */
812 library SafeERC20 {
813     using SafeMath for uint256;
814     using Address for address;
815 
816     function safeTransfer(IERC20 token, address to, uint256 value) internal {
817         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
818     }
819 
820     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
821         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
822     }
823 
824     /**
825      * @dev Deprecated. This function has issues similar to the ones found in
826      * {IERC20-approve}, and its usage is discouraged.
827      *
828      * Whenever possible, use {safeIncreaseAllowance} and
829      * {safeDecreaseAllowance} instead.
830      */
831     function safeApprove(IERC20 token, address spender, uint256 value) internal {
832         // safeApprove should only be called when setting an initial allowance,
833         // or when resetting it to zero. To increase and decrease it, use
834         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
835         // solhint-disable-next-line max-line-length
836         require((value == 0) || (token.allowance(address(this), spender) == 0),
837             "SafeERC20: approve from non-zero to non-zero allowance"
838         );
839         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
840     }
841 
842     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
843         uint256 newAllowance = token.allowance(address(this), spender).add(value);
844         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
845     }
846 
847     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
848         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
849         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
850     }
851 
852     /**
853      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
854      * on the return value: the return value is optional (but if data is returned, it must not be false).
855      * @param token The token targeted by the call.
856      * @param data The call data (encoded using abi.encode or one of its variants).
857      */
858     function _callOptionalReturn(IERC20 token, bytes memory data) private {
859         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
860         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
861         // the target address contains contract code and also asserts for success in the low-level call.
862 
863         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
864         if (returndata.length > 0) { // Return data is optional
865             // solhint-disable-next-line max-line-length
866             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
867         }
868     }
869 }
870 
871 // File: contracts/token/STRN.sol
872 
873 // SPDX-License-Identifier: GPL-3.0-or-later
874 
875 pragma solidity 0.5.15;
876 
877 /* import "./STRNTokenInterface.sol"; */
878 
879 contract STRNToken is STRNGovernanceToken {
880     // Modifiers
881     modifier onlyGov() {
882         require(msg.sender == gov);
883         _;
884     }
885 
886     modifier onlyMinter() {
887         require(
888             msg.sender == gov
889             || msg.sender == incentivizer,
890             "not minter"
891         );
892         _;
893     }
894 
895     modifier validRecipient(address to) {
896         require(to != address(0x0));
897         require(to != address(this));
898         _;
899     }
900 
901     function initialize(
902         string memory name_,
903         string memory symbol_,
904         uint8 decimals_,
905         uint256 maxSupply_
906     )
907         public
908     {
909         name = name_;
910         symbol = symbol_;
911         decimals = decimals_;
912         maxSupply = maxSupply_;
913     }
914 
915 
916     /**
917     * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
918     * @dev Limited to onlyMinter modifier
919     */
920     function mint(address to, uint256 amount)
921         external
922         onlyMinter
923         returns (bool)
924     {
925         _mint(to, amount);
926         return true;
927     }
928 
929     function _mint(address to, uint256 amount)
930         internal
931     {
932         uint256 newTotalSupply = totalSupply.add(amount);
933         require(newTotalSupply <= maxSupply);
934         // increase totalSupply
935         totalSupply = newTotalSupply;
936 
937         // add balance
938         _strnBalances[to] = _strnBalances[to].add(amount);
939 
940         // add delegates to the minter
941         _moveDelegates(address(0), _delegates[to], amount);
942         emit Mint(to, amount);
943         emit Transfer(address(0), to, amount);
944     }
945 
946     /* - ERC20 functionality - */
947 
948     /**
949     * @dev Transfer tokens to a specified address.
950     * @param to The address to transfer to.
951     * @param value The amount to be transferred.
952     * @return True on success, false otherwise.
953     */
954     function transfer(address to, uint256 value)
955         external
956         validRecipient(to)
957         returns (bool)
958     {
959         // underlying balance is stored in yams, so divide by current scaling factor
960 
961         // sub from balance of sender
962         _strnBalances[msg.sender] = _strnBalances[msg.sender].sub(value);
963 
964         // add to balance of receiver
965         _strnBalances[to] = _strnBalances[to].add(value);
966         emit Transfer(msg.sender, to, value);
967 
968         _moveDelegates(_delegates[msg.sender], _delegates[to], value);
969         return true;
970     }
971 
972     /**
973     * @dev Transfer tokens from one address to another.
974     * @param from The address you want to send tokens from.
975     * @param to The address you want to transfer to.
976     * @param value The amount of tokens to be transferred.
977     */
978     function transferFrom(address from, address to, uint256 value)
979         external
980         validRecipient(to)
981         returns (bool)
982     {
983         // decrease allowance
984         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
985 
986         // sub from from
987         _strnBalances[from] = _strnBalances[from].sub(value);
988         _strnBalances[to] = _strnBalances[to].add(value);
989         emit Transfer(from, to, value);
990 
991         _moveDelegates(_delegates[from], _delegates[to], value);
992         return true;
993     }
994 
995     /**
996     * @param who The address to query.
997     * @return The balance of the specified address.
998     */
999     function balanceOf(address who)
1000       external
1001       view
1002       returns (uint256)
1003     {
1004       return _strnBalances[who];
1005     }
1006 
1007     /**
1008      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1009      * @param owner_ The address which owns the funds.
1010      * @param spender The address which will spend the funds.
1011      * @return The number of tokens still available for the spender.
1012      */
1013     function allowance(address owner_, address spender)
1014         external
1015         view
1016         returns (uint256)
1017     {
1018         return _allowedFragments[owner_][spender];
1019     }
1020 
1021     /**
1022      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1023      * msg.sender. This method is included for ERC20 compatibility.
1024      * increaseAllowance and decreaseAllowance should be used instead.
1025      * Changing an allowance with this method brings the risk that someone may transfer both
1026      * the old and the new allowance - if they are both greater than zero - if a transfer
1027      * transaction is mined before the later approve() call is mined.
1028      *
1029      * @param spender The address which will spend the funds.
1030      * @param value The amount of tokens to be spent.
1031      */
1032     function approve(address spender, uint256 value)
1033         external
1034         returns (bool)
1035     {
1036         _allowedFragments[msg.sender][spender] = value;
1037         emit Approval(msg.sender, spender, value);
1038         return true;
1039     }
1040 
1041     /**
1042      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1043      * This method should be used instead of approve() to avoid the double approval vulnerability
1044      * described above.
1045      * @param spender The address which will spend the funds.
1046      * @param addedValue The amount of tokens to increase the allowance by.
1047      */
1048     function increaseAllowance(address spender, uint256 addedValue)
1049         external
1050         returns (bool)
1051     {
1052         _allowedFragments[msg.sender][spender] =
1053             _allowedFragments[msg.sender][spender].add(addedValue);
1054         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
1055         return true;
1056     }
1057 
1058     /**
1059      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1060      *
1061      * @param spender The address which will spend the funds.
1062      * @param subtractedValue The amount of tokens to decrease the allowance by.
1063      */
1064     function decreaseAllowance(address spender, uint256 subtractedValue)
1065         external
1066         returns (bool)
1067     {
1068         uint256 oldValue = _allowedFragments[msg.sender][spender];
1069         if (subtractedValue >= oldValue) {
1070             _allowedFragments[msg.sender][spender] = 0;
1071         } else {
1072             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
1073         }
1074         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
1075         return true;
1076     }
1077 
1078 
1079     // --- Approve by signature ---
1080     function permit(
1081         address owner,
1082         address spender,
1083         uint256 value,
1084         uint256 deadline,
1085         uint8 v,
1086         bytes32 r,
1087         bytes32 s
1088     )
1089         external
1090     {
1091         require(now <= deadline, "STRN/permit-expired");
1092 
1093         bytes32 digest =
1094             keccak256(
1095                 abi.encodePacked(
1096                     "\x19\x01",
1097                     DOMAIN_SEPARATOR,
1098                     keccak256(
1099                         abi.encode(
1100                             PERMIT_TYPEHASH,
1101                             owner,
1102                             spender,
1103                             value,
1104                             nonces[owner]++,
1105                             deadline
1106                         )
1107                     )
1108                 )
1109             );
1110 
1111         require(owner != address(0), "STRN/invalid-address-0");
1112         require(owner == ecrecover(digest, v, r, s), "STRN/invalid-permit");
1113         _allowedFragments[owner][spender] = value;
1114         emit Approval(owner, spender, value);
1115     }
1116 
1117     /* - Governance Functions - */
1118 
1119     /** @notice sets the incentivizer
1120      * @param incentivizer_ The address of the incentivizer contract to use for authentication.
1121      */
1122     function _setIncentivizer(address incentivizer_)
1123         external
1124         onlyGov
1125     {
1126         address oldIncentivizer = incentivizer;
1127         incentivizer = incentivizer_;
1128         emit NewIncentivizer(oldIncentivizer, incentivizer_);
1129     }
1130 
1131     /** @notice sets the pendingGov
1132      * @param pendingGov_ The address of the pendinggov contract to use for authentication.
1133      */
1134     function _setPendingGov(address pendingGov_)
1135         external
1136         onlyGov
1137     {
1138         address oldPendingGov = pendingGov;
1139         pendingGov = pendingGov_;
1140         emit NewPendingGov(oldPendingGov, pendingGov_);
1141     }
1142 
1143     /** @notice lets msg.sender accept governance
1144      *
1145      */
1146     function _acceptGov()
1147         external
1148     {
1149         require(msg.sender == pendingGov, "!pending");
1150         address oldGov = gov;
1151         gov = pendingGov;
1152         pendingGov = address(0);
1153         emit NewGov(oldGov, gov);
1154     }
1155 
1156     /* - Extras - */
1157 
1158     // Rescue tokens
1159     function rescueTokens(
1160         address token,
1161         address to,
1162         uint256 amount
1163     )
1164         external
1165         onlyGov
1166         returns (bool)
1167     {
1168         // transfer to
1169         SafeERC20.safeTransfer(IERC20(token), to, amount);
1170         return true;
1171     }
1172 }
1173 
1174 contract STRN is STRNToken {
1175     /**
1176      * @notice Initialize the new money market
1177      * @param name_ ERC-20 name of this token
1178      * @param symbol_ ERC-20 symbol of this token
1179      * @param decimals_ ERC-20 decimal precision of this token
1180      */
1181     function initialize(
1182         string memory name_,
1183         string memory symbol_,
1184         uint8 decimals_,
1185         address initial_owner,
1186         uint256 initTotalSupply_,
1187         uint256 maxSupply_
1188     )
1189         public
1190     {
1191         super.initialize(name_, symbol_, decimals_, maxSupply_);
1192 
1193         initSupply = initTotalSupply_;
1194         totalSupply = initTotalSupply_;
1195         _strnBalances[initial_owner] = initSupply;
1196 
1197         DOMAIN_SEPARATOR = keccak256(
1198             abi.encode(
1199                 DOMAIN_TYPEHASH,
1200                 keccak256(bytes(name)),
1201                 getChainId(),
1202                 address(this)
1203             )
1204         );
1205     }
1206 }
1207 
1208 // File: contracts/token/STRNDelegate.sol
1209 
1210 pragma solidity 0.5.15;
1211 
1212 /* Copyright 2020 Compound Labs, Inc.
1213 
1214 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1215 
1216 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
1217 
1218 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
1219 
1220 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
1221 
1222 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
1223 
1224 
1225 contract STRNDelegationStorage {
1226     /**
1227      * @notice Implementation address for this contract
1228      */
1229     address public implementation;
1230 }
1231 
1232 contract STRNDelegatorInterface is STRNDelegationStorage {
1233     /**
1234      * @notice Emitted when implementation is changed
1235      */
1236     event NewImplementation(address oldImplementation, address newImplementation);
1237 
1238     /**
1239      * @notice Called by the gov to update the implementation of the delegator
1240      * @param implementation_ The address of the new implementation for delegation
1241      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1242      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1243      */
1244     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
1245 }
1246 
1247 contract STRNDelegateInterface is STRNDelegationStorage {
1248     /**
1249      * @notice Called by the delegator on a delegate to initialize it for duty
1250      * @dev Should revert if any issues arise which make it unfit for delegation
1251      * @param data The encoded bytes data for any initialization
1252      */
1253     function _becomeImplementation(bytes memory data) public;
1254 
1255     /**
1256      * @notice Called by the delegator on a delegate to forfeit its responsibility
1257      */
1258     function _resignImplementation() public;
1259 }
1260 
1261 
1262 contract STRNDelegate is STRN, STRNDelegateInterface {
1263     /**
1264      * @notice Construct an empty delegate
1265      */
1266     constructor() public {}
1267 
1268     /**
1269      * @notice Called by the delegator on a delegate to initialize it for duty
1270      * @param data The encoded bytes data for any initialization
1271      */
1272     function _becomeImplementation(bytes memory data) public {
1273         // Shh -- currently unused
1274         data;
1275 
1276         // Shh -- we don't ever want this hook to be marked pure
1277         if (false) {
1278             implementation = address(0);
1279         }
1280 
1281         require(msg.sender == gov, "only the gov may call _becomeImplementation");
1282     }
1283 
1284     /**
1285      * @notice Called by the delegator on a delegate to forfeit its responsibility
1286      */
1287     function _resignImplementation() public {
1288         // Shh -- we don't ever want this hook to be marked pure
1289         if (false) {
1290             implementation = address(0);
1291         }
1292 
1293         require(msg.sender == gov, "only the gov may call _resignImplementation");
1294     }
1295 }
1296 
1297 // File: contracts/token/STRNDelegator.sol
1298 
1299 // SPDX-License-Identifier: GPL-3.0-or-later
1300 
1301 pragma solidity 0.5.15;
1302 
1303 contract STRNDelegator is STRNTokenInterface, STRNDelegatorInterface {
1304     /**
1305      * @notice Construct a new STRN
1306      * @param name_ ERC-20 name of this token
1307      * @param symbol_ ERC-20 symbol of this token
1308      * @param decimals_ ERC-20 decimal precision of this token
1309      * @param initTotalSupply_ Initial token amount
1310      * @param implementation_ The address of the implementation the contract delegates to
1311      * @param becomeImplementationData The encoded args for becomeImplementation
1312      */
1313     constructor(
1314         string memory name_,
1315         string memory symbol_,
1316         uint8 decimals_,
1317         uint256 initTotalSupply_,
1318         uint256 maxSupply_,
1319         address implementation_,
1320         bytes memory becomeImplementationData
1321     )
1322         public
1323     {
1324 
1325 
1326         // Creator of the contract is gov during initialization
1327         gov = msg.sender;
1328 
1329         // First delegate gets to initialize the delegator (i.e. storage contract)
1330         delegateTo(
1331             implementation_,
1332             abi.encodeWithSignature(
1333                 "initialize(string,string,uint8,address,uint256,uint256)",
1334                 name_,
1335                 symbol_,
1336                 decimals_,
1337                 msg.sender,
1338                 initTotalSupply_,
1339                 maxSupply_
1340             )
1341         );
1342 
1343         // New implementations always get set via the settor (post-initialize)
1344         _setImplementation(implementation_, false, becomeImplementationData);
1345 
1346     }
1347 
1348     /**
1349      * @notice Called by the gov to update the implementation of the delegator
1350      * @param implementation_ The address of the new implementation for delegation
1351      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1352      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1353      */
1354     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
1355         require(msg.sender == gov, "STRNDelegator::_setImplementation: Caller must be gov");
1356 
1357         if (allowResign) {
1358             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
1359         }
1360 
1361         address oldImplementation = implementation;
1362         implementation = implementation_;
1363 
1364         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
1365 
1366         emit NewImplementation(oldImplementation, implementation);
1367     }
1368 
1369     /**
1370      * @notice Sender supplies assets into the market and receives cTokens in exchange
1371      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1372      * @param mintAmount The amount of the underlying asset to supply
1373      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1374      */
1375     function mint(address to, uint256 mintAmount)
1376         external
1377         returns (bool)
1378     {
1379         to; mintAmount; // Shh
1380         delegateAndReturn();
1381     }
1382 
1383     /**
1384      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1385      * @param dst The address of the destination account
1386      * @param amount The number of tokens to transfer
1387      * @return Whether or not the transfer succeeded
1388      */
1389     function transfer(address dst, uint256 amount)
1390         external
1391         returns (bool)
1392     {
1393         dst; amount; // Shh
1394         delegateAndReturn();
1395     }
1396 
1397     /**
1398      * @notice Transfer `amount` tokens from `src` to `dst`
1399      * @param src The address of the source account
1400      * @param dst The address of the destination account
1401      * @param amount The number of tokens to transfer
1402      * @return Whether or not the transfer succeeded
1403      */
1404     function transferFrom(
1405         address src,
1406         address dst,
1407         uint256 amount
1408     )
1409         external
1410         returns (bool)
1411     {
1412         src; dst; amount; // Shh
1413         delegateAndReturn();
1414     }
1415 
1416     /**
1417      * @notice Approve `spender` to transfer up to `amount` from `src`
1418      * @dev This will overwrite the approval amount for `spender`
1419      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1420      * @param spender The address of the account which may transfer tokens
1421      * @param amount The number of tokens that are approved (-1 means infinite)
1422      * @return Whether or not the approval succeeded
1423      */
1424     function approve(
1425         address spender,
1426         uint256 amount
1427     )
1428         external
1429         returns (bool)
1430     {
1431         spender; amount; // Shh
1432         delegateAndReturn();
1433     }
1434 
1435     /**
1436      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1437      * This method should be used instead of approve() to avoid the double approval vulnerability
1438      * described above.
1439      * @param spender The address which will spend the funds.
1440      * @param addedValue The amount of tokens to increase the allowance by.
1441      */
1442     function increaseAllowance(
1443         address spender,
1444         uint256 addedValue
1445     )
1446         external
1447         returns (bool)
1448     {
1449         spender; addedValue; // Shh
1450         delegateAndReturn();
1451     }
1452 
1453 
1454 
1455     function maxScalingFactor()
1456         external
1457         view
1458         returns (uint256)
1459     {
1460         delegateToViewAndReturn();
1461     }
1462 
1463     /**
1464      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1465      *
1466      * @param spender The address which will spend the funds.
1467      * @param subtractedValue The amount of tokens to decrease the allowance by.
1468      */
1469     function decreaseAllowance(
1470         address spender,
1471         uint256 subtractedValue
1472     )
1473         external
1474         returns (bool)
1475     {
1476         spender; subtractedValue; // Shh
1477         delegateAndReturn();
1478     }
1479 
1480 
1481     // --- Approve by signature ---
1482     function permit(
1483         address owner,
1484         address spender,
1485         uint256 value,
1486         uint256 deadline,
1487         uint8 v,
1488         bytes32 r,
1489         bytes32 s
1490     )
1491         external
1492     {
1493         owner; spender; value; deadline; v; r; s; // Shh
1494         delegateAndReturn();
1495     }
1496 
1497     /**
1498      * @notice Get the current allowance from `owner` for `spender`
1499      * @param owner The address of the account which owns the tokens to be spent
1500      * @param spender The address of the account which may transfer tokens
1501      * @return The number of tokens allowed to be spent (-1 means infinite)
1502      */
1503     function allowance(
1504         address owner,
1505         address spender
1506     )
1507         external
1508         view
1509         returns (uint256)
1510     {
1511         owner; spender; // Shh
1512         delegateToViewAndReturn();
1513     }
1514 
1515 
1516     /**
1517      * @notice Rescues tokens and sends them to the `to` address
1518      * @param token The address of the token
1519      * @param to The address for which the tokens should be send
1520      * @return Success
1521      */
1522     function rescueTokens(
1523         address token,
1524         address to,
1525         uint256 amount
1526     )
1527         external
1528         returns (bool)
1529     {
1530         token; to; amount; // Shh
1531         delegateAndReturn();
1532     }
1533 
1534     /**
1535      * @notice Get the current allowance from `owner` for `spender`
1536      * @param delegator The address of the account which has designated a delegate
1537      * @return Address of delegatee
1538      */
1539     function delegates(
1540         address delegator
1541     )
1542         external
1543         view
1544         returns (address)
1545     {
1546         delegator; // Shh
1547         delegateToViewAndReturn();
1548     }
1549 
1550     /**
1551      * @notice Get the token balance of the `owner`
1552      * @param owner The address of the account to query
1553      * @return The number of tokens owned by `owner`
1554      */
1555     function balanceOf(address owner)
1556         external
1557         view
1558         returns (uint256)
1559     {
1560         owner; // Shh
1561         delegateToViewAndReturn();
1562     }
1563 
1564     /*** Gov Functions ***/
1565 
1566     /**
1567       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
1568       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
1569       * @param newPendingGov New pending gov.
1570       */
1571     function _setPendingGov(address newPendingGov)
1572         external
1573     {
1574         newPendingGov; // Shh
1575         delegateAndReturn();
1576     }
1577 
1578     function _setIncentivizer(address incentivizer_)
1579         external
1580     {
1581         incentivizer_; // Shh
1582         delegateAndReturn();
1583     }
1584 
1585     /**
1586       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
1587       * @dev Gov function for pending gov to accept role and update gov
1588       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1589       */
1590     function _acceptGov()
1591         external
1592     {
1593         delegateAndReturn();
1594     }
1595 
1596 
1597     function getPriorVotes(address account, uint blockNumber)
1598         external
1599         view
1600         returns (uint256)
1601     {
1602         account; blockNumber;
1603         delegateToViewAndReturn();
1604     }
1605 
1606     function delegateBySig(
1607         address delegatee,
1608         uint nonce,
1609         uint expiry,
1610         uint8 v,
1611         bytes32 r,
1612         bytes32 s
1613     )
1614         external
1615     {
1616         delegatee; nonce; expiry; v; r; s;
1617         delegateAndReturn();
1618     }
1619 
1620     function delegate(address delegatee)
1621         external
1622     {
1623         delegatee;
1624         delegateAndReturn();
1625     }
1626 
1627     function getCurrentVotes(address account)
1628         external
1629         view
1630         returns (uint256)
1631     {
1632         account;
1633         delegateToViewAndReturn();
1634     }
1635 
1636     /**
1637      * @notice Internal method to delegate execution to another contract
1638      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1639      * @param callee The contract to delegatecall
1640      * @param data The raw data to delegatecall
1641      * @return The returned bytes from the delegatecall
1642      */
1643     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
1644         (bool success, bytes memory returnData) = callee.delegatecall(data);
1645         assembly {
1646             if eq(success, 0) {
1647                 revert(add(returnData, 0x20), returndatasize)
1648             }
1649         }
1650         return returnData;
1651     }
1652 
1653     /**
1654      * @notice Delegates execution to the implementation contract
1655      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1656      * @param data The raw data to delegatecall
1657      * @return The returned bytes from the delegatecall
1658      */
1659     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
1660         return delegateTo(implementation, data);
1661     }
1662 
1663     /**
1664      * @notice Delegates execution to an implementation contract
1665      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1666      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1667      * @param data The raw data to delegatecall
1668      * @return The returned bytes from the delegatecall
1669      */
1670     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
1671         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
1672         assembly {
1673             if eq(success, 0) {
1674                 revert(add(returnData, 0x20), returndatasize)
1675             }
1676         }
1677         return abi.decode(returnData, (bytes));
1678     }
1679 
1680     function delegateToViewAndReturn() private view returns (bytes memory) {
1681         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
1682 
1683         assembly {
1684             let free_mem_ptr := mload(0x40)
1685             returndatacopy(free_mem_ptr, 0, returndatasize)
1686 
1687             switch success
1688             case 0 { revert(free_mem_ptr, returndatasize) }
1689             default { return(add(free_mem_ptr, 0x40), sub(returndatasize, 0x40)) }
1690         }
1691     }
1692 
1693     function delegateAndReturn() private returns (bytes memory) {
1694         (bool success, ) = implementation.delegatecall(msg.data);
1695 
1696         assembly {
1697             let free_mem_ptr := mload(0x40)
1698             returndatacopy(free_mem_ptr, 0, returndatasize)
1699 
1700             switch success
1701             case 0 { revert(free_mem_ptr, returndatasize) }
1702             default { return(free_mem_ptr, returndatasize) }
1703         }
1704     }
1705 
1706     /**
1707      * @notice Delegates execution to an implementation contract
1708      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1709      */
1710     function() external payable {
1711         require(msg.value == 0,"STRNDelegator:fallback: cannot send value to fallback");
1712 
1713         // delegate all other functions to current implementation
1714         delegateAndReturn();
1715     }
1716 }