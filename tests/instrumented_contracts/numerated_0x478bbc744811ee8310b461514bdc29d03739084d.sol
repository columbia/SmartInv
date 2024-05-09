1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-05
3  */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.12;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender)
41         external
42         view
43         returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(
89         address indexed owner,
90         address indexed spender,
91         uint256 value
92     );
93 }
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "add: +");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      * - Addition cannot overflow.
131      */
132     function add(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, errorMessage);
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      * - Subtraction cannot underflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "sub: -");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      * - Subtraction cannot underflow.
162      */
163     function sub(
164         uint256 a,
165         uint256 b,
166         string memory errorMessage
167     ) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "mul: *");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      * - Multiplication cannot overflow.
203      */
204     function mul(
205         uint256 a,
206         uint256 b,
207         string memory errorMessage
208     ) internal pure returns (uint256) {
209         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210         // benefit is lost if 'b' is also tested.
211         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
212         if (a == 0) {
213             return 0;
214         }
215 
216         uint256 c = a * b;
217         require(c / a == b, errorMessage);
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers.
224      * Reverts on division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return div(a, b, "div: /");
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers.
239      * Reverts with custom message on division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function div(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         // Solidity only automatically asserts when dividing by 0
254         require(b > 0, errorMessage);
255         uint256 c = a / b;
256         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
273         return mod(a, b, "mod: %");
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * Reverts with custom message when dividing by zero.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      */
287     function mod(
288         uint256 a,
289         uint256 b,
290         string memory errorMessage
291     ) internal pure returns (uint256) {
292         require(b != 0, errorMessage);
293         return a % b;
294     }
295 }
296 
297 interface StrategyProxy {
298     function lock() external;
299 }
300 
301 interface FeeDistribution {
302     function claim(address) external;
303 }
304 
305 contract veCurveVault {
306     using SafeMath for uint256;
307 
308     /// @notice EIP-20 token name for this token
309     string public constant name = "veCRV Stake DAO";
310 
311     /// @notice EIP-20 token symbol for this token
312     string public constant symbol = "sdveCRV-DAO";
313 
314     /// @notice EIP-20 token decimals for this token
315     uint8 public constant decimals = 18;
316 
317     /// @notice Total number of tokens in circulation
318     uint256 public totalSupply = 0; // Initial 0
319 
320     /// @notice A record of each accounts delegate
321     mapping(address => address) public delegates;
322 
323     /// @notice A record of votes checkpoints for each account, by index
324     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
325 
326     /// @notice The number of checkpoints for each account
327     mapping(address => uint32) public numCheckpoints;
328 
329     mapping(address => mapping(address => uint256)) internal allowances;
330     mapping(address => uint256) internal balances;
331 
332     /// @notice The EIP-712 typehash for the contract's domain
333     bytes32 public constant DOMAIN_TYPEHASH =
334         keccak256(
335             "EIP712Domain(string name,uint chainId,address verifyingContract)"
336         );
337     bytes32 public immutable DOMAINSEPARATOR;
338 
339     /// @notice The EIP-712 typehash for the delegation struct used by the contract
340     bytes32 public constant DELEGATION_TYPEHASH =
341         keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
342 
343     /// @notice The EIP-712 typehash for the permit struct used by the contract
344     bytes32 public constant PERMIT_TYPEHASH =
345         keccak256(
346             "Permit(address owner,address spender,uint value,uint nonce,uint deadline)"
347         );
348 
349     /// @notice A record of states for signing / validating signatures
350     mapping(address => uint256) public nonces;
351 
352     /// @notice An event thats emitted when an account changes its delegate
353     event DelegateChanged(
354         address indexed delegator,
355         address indexed fromDelegate,
356         address indexed toDelegate
357     );
358 
359     /// @notice An event thats emitted when a delegate account's vote balance changes
360     event DelegateVotesChanged(
361         address indexed delegate,
362         uint256 previousBalance,
363         uint256 newBalance
364     );
365 
366     /// @notice A checkpoint for marking number of votes from a given block
367     struct Checkpoint {
368         uint32 fromBlock;
369         uint256 votes;
370     }
371 
372     /**
373      * @notice Delegate votes from `msg.sender` to `delegatee`
374      * @param delegatee The address to delegate votes to
375      */
376     function delegate(address delegatee) public {
377         _delegate(msg.sender, delegatee);
378     }
379 
380     /**
381      * @notice Delegates votes from signatory to `delegatee`
382      * @param delegatee The address to delegate votes to
383      * @param nonce The contract state required to match the signature
384      * @param expiry The time at which to expire the signature
385      * @param v The recovery byte of the signature
386      * @param r Half of the ECDSA signature pair
387      * @param s Half of the ECDSA signature pair
388      */
389     function delegateBySig(
390         address delegatee,
391         uint256 nonce,
392         uint256 expiry,
393         uint8 v,
394         bytes32 r,
395         bytes32 s
396     ) public {
397         bytes32 structHash =
398             keccak256(
399                 abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
400             );
401         bytes32 digest =
402             keccak256(
403                 abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash)
404             );
405         address signatory = ecrecover(digest, v, r, s);
406         require(signatory != address(0), "delegateBySig: sig");
407         require(nonce == nonces[signatory]++, "delegateBySig: nonce");
408         require(now <= expiry, "delegateBySig: expired");
409         _delegate(signatory, delegatee);
410     }
411 
412     /**
413      * @notice Gets the current votes balance for `account`
414      * @param account The address to get votes balance
415      * @return The number of current votes for `account`
416      */
417     function getCurrentVotes(address account) external view returns (uint256) {
418         uint32 nCheckpoints = numCheckpoints[account];
419         return
420             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
421     }
422 
423     /**
424      * @notice Determine the prior number of votes for an account as of a block number
425      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
426      * @param account The address of the account to check
427      * @param blockNumber The block number to get the vote balance at
428      * @return The number of votes the account had as of the given block
429      */
430     function getPriorVotes(address account, uint256 blockNumber)
431         public
432         view
433         returns (uint256)
434     {
435         require(blockNumber < block.number, "getPriorVotes:");
436 
437         uint32 nCheckpoints = numCheckpoints[account];
438         if (nCheckpoints == 0) {
439             return 0;
440         }
441 
442         // First check most recent balance
443         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
444             return checkpoints[account][nCheckpoints - 1].votes;
445         }
446 
447         // Next check implicit zero balance
448         if (checkpoints[account][0].fromBlock > blockNumber) {
449             return 0;
450         }
451 
452         uint32 lower = 0;
453         uint32 upper = nCheckpoints - 1;
454         while (upper > lower) {
455             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
456             Checkpoint memory cp = checkpoints[account][center];
457             if (cp.fromBlock == blockNumber) {
458                 return cp.votes;
459             } else if (cp.fromBlock < blockNumber) {
460                 lower = center;
461             } else {
462                 upper = center - 1;
463             }
464         }
465         return checkpoints[account][lower].votes;
466     }
467 
468     function _delegate(address delegator, address delegatee) internal {
469         address currentDelegate = delegates[delegator];
470         uint256 delegatorBalance = balances[delegator];
471         delegates[delegator] = delegatee;
472 
473         emit DelegateChanged(delegator, currentDelegate, delegatee);
474 
475         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
476     }
477 
478     function _moveDelegates(
479         address srcRep,
480         address dstRep,
481         uint256 amount
482     ) internal {
483         if (srcRep != dstRep && amount > 0) {
484             if (srcRep != address(0)) {
485                 uint32 srcRepNum = numCheckpoints[srcRep];
486                 uint256 srcRepOld =
487                     srcRepNum > 0
488                         ? checkpoints[srcRep][srcRepNum - 1].votes
489                         : 0;
490                 uint256 srcRepNew =
491                     srcRepOld.sub(amount, "_moveVotes: underflows");
492                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
493             }
494 
495             if (dstRep != address(0)) {
496                 uint32 dstRepNum = numCheckpoints[dstRep];
497                 uint256 dstRepOld =
498                     dstRepNum > 0
499                         ? checkpoints[dstRep][dstRepNum - 1].votes
500                         : 0;
501                 uint256 dstRepNew = dstRepOld.add(amount);
502                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
503             }
504         }
505     }
506 
507     function _writeCheckpoint(
508         address delegatee,
509         uint32 nCheckpoints,
510         uint256 oldVotes,
511         uint256 newVotes
512     ) internal {
513         uint32 blockNumber = safe32(block.number, "_writeCheckpoint: 32 bits");
514 
515         if (
516             nCheckpoints > 0 &&
517             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
518         ) {
519             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
520         } else {
521             checkpoints[delegatee][nCheckpoints] = Checkpoint(
522                 blockNumber,
523                 newVotes
524             );
525             numCheckpoints[delegatee] = nCheckpoints + 1;
526         }
527 
528         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
529     }
530 
531     function safe32(uint256 n, string memory errorMessage)
532         internal
533         pure
534         returns (uint32)
535     {
536         require(n < 2**32, errorMessage);
537         return uint32(n);
538     }
539 
540     /// @notice The standard EIP-20 transfer event
541     event Transfer(address indexed from, address indexed to, uint256 amount);
542 
543     /// @notice The standard EIP-20 approval event
544     event Approval(
545         address indexed owner,
546         address indexed spender,
547         uint256 amount
548     );
549 
550     /// @notice governance address for the governance contract
551     address public governance;
552     address public pendingGovernance;
553 
554     IERC20 public constant CRV =
555         IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52);
556     /* address public constant LOCK = address(0xF147b8125d2ef93FB6965Db97D6746952a133934); */
557     address public constant LOCK =
558         address(0x52f541764E6e90eeBc5c21Ff570De0e2D63766B6);
559     address public proxy = address(0x7A1848e7847F3f5FfB4d8e63BdB9569db535A4f0);
560     address public feeDistribution;
561 
562     IERC20 public constant rewards =
563         IERC20(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
564 
565     uint256 public index = 0;
566     uint256 public bal = 0;
567 
568     mapping(address => uint256) public supplyIndex;
569 
570     function update() external {
571         _update();
572     }
573 
574     function _update() internal {
575         if (totalSupply > 0) {
576             _claim();
577             uint256 _bal = rewards.balanceOf(address(this));
578             if (_bal > bal) {
579                 uint256 _diff = _bal.sub(bal, "veCRV::_update: bal _diff");
580                 if (_diff > 0) {
581                     uint256 _ratio = _diff.mul(1e18).div(totalSupply);
582                     if (_ratio > 0) {
583                         index = index.add(_ratio);
584                         bal = _bal;
585                     }
586                 }
587             }
588         }
589     }
590 
591     function _claim() internal {
592         if (feeDistribution != address(0x0)) {
593             FeeDistribution(feeDistribution).claim(address(this));
594         }
595     }
596 
597     function updateFor(address recipient) public {
598         _update();
599         uint256 _supplied = balances[recipient];
600         if (_supplied > 0) {
601             uint256 _supplyIndex = supplyIndex[recipient];
602             supplyIndex[recipient] = index;
603             uint256 _delta =
604                 index.sub(_supplyIndex, "veCRV::_claimFor: index delta");
605             if (_delta > 0) {
606                 uint256 _share = _supplied.mul(_delta).div(1e18);
607                 claimable[recipient] = claimable[recipient].add(_share);
608             }
609         } else {
610             supplyIndex[recipient] = index;
611         }
612     }
613 
614     mapping(address => uint256) public claimable;
615 
616     function claim() external {
617         _claimFor(msg.sender);
618     }
619 
620     function claimFor(address recipient) external {
621         _claimFor(recipient);
622     }
623 
624     function _claimFor(address recipient) internal {
625         updateFor(recipient);
626         rewards.transfer(recipient, claimable[recipient]);
627         claimable[recipient] = 0;
628         bal = rewards.balanceOf(address(this));
629     }
630 
631     constructor() public {
632         // Set governance for this token
633         governance = msg.sender;
634         DOMAINSEPARATOR = keccak256(
635             abi.encode(
636                 DOMAIN_TYPEHASH,
637                 keccak256(bytes(name)),
638                 _getChainId(),
639                 address(this)
640             )
641         );
642     }
643 
644     function _mint(address dst, uint256 amount) internal {
645         updateFor(dst);
646         // mint the amount
647         totalSupply = totalSupply.add(amount);
648         // transfer the amount to the recipient
649         balances[dst] = balances[dst].add(amount);
650         emit Transfer(address(0), dst, amount);
651 
652         // move delegates
653         _moveDelegates(address(0), delegates[dst], amount);
654     }
655 
656     function depositAll() external {
657         _deposit(CRV.balanceOf(msg.sender));
658     }
659 
660     function deposit(uint256 _amount) external {
661         _deposit(_amount);
662     }
663 
664     function _deposit(uint256 _amount) internal {
665         CRV.transferFrom(msg.sender, LOCK, _amount);
666         _mint(msg.sender, _amount);
667         StrategyProxy(proxy).lock();
668     }
669 
670     function setProxy(address _proxy) external {
671         require(msg.sender == governance, "setGovernance: !gov");
672         proxy = _proxy;
673     }
674 
675     function setFeeDistribution(address _feeDistribution) external {
676         require(msg.sender == governance, "setGovernance: !gov");
677         feeDistribution = _feeDistribution;
678     }
679 
680     /**
681      * @notice Allows governance to change governance (for future upgradability)
682      * @param _governance new governance address to set
683      */
684     function setGovernance(address _governance) external {
685         require(msg.sender == governance, "setGovernance: !gov");
686         pendingGovernance = _governance;
687     }
688 
689     /**
690      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
691      */
692     function acceptGovernance() external {
693         require(
694             msg.sender == pendingGovernance,
695             "acceptGovernance: !pendingGov"
696         );
697         governance = pendingGovernance;
698     }
699 
700     /**
701      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
702      * @param account The address of the account holding the funds
703      * @param spender The address of the account spending the funds
704      * @return The number of tokens approved
705      */
706     function allowance(address account, address spender)
707         external
708         view
709         returns (uint256)
710     {
711         return allowances[account][spender];
712     }
713 
714     /**
715      * @notice Approve `spender` to transfer up to `amount` from `src`
716      * @dev This will overwrite the approval amount for `spender`
717      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
718      * @param spender The address of the account which may transfer tokens
719      * @param amount The number of tokens that are approved (2^256-1 means infinite)
720      * @return Whether or not the approval succeeded
721      */
722     function approve(address spender, uint256 amount) external returns (bool) {
723         allowances[msg.sender][spender] = amount;
724 
725         emit Approval(msg.sender, spender, amount);
726         return true;
727     }
728 
729     /**
730      * @notice Triggers an approval from owner to spends
731      * @param owner The address to approve from
732      * @param spender The address to be approved
733      * @param amount The number of tokens that are approved (2^256-1 means infinite)
734      * @param deadline The time at which to expire the signature
735      * @param v The recovery byte of the signature
736      * @param r Half of the ECDSA signature pair
737      * @param s Half of the ECDSA signature pair
738      */
739     function permit(
740         address owner,
741         address spender,
742         uint256 amount,
743         uint256 deadline,
744         uint8 v,
745         bytes32 r,
746         bytes32 s
747     ) external {
748         bytes32 structHash =
749             keccak256(
750                 abi.encode(
751                     PERMIT_TYPEHASH,
752                     owner,
753                     spender,
754                     amount,
755                     nonces[owner]++,
756                     deadline
757                 )
758             );
759         bytes32 digest =
760             keccak256(
761                 abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash)
762             );
763         address signatory = ecrecover(digest, v, r, s);
764         require(signatory != address(0), "permit: signature");
765         require(signatory == owner, "permit: unauthorized");
766         require(now <= deadline, "permit: expired");
767 
768         allowances[owner][spender] = amount;
769 
770         emit Approval(owner, spender, amount);
771     }
772 
773     /**
774      * @notice Get the number of tokens held by the `account`
775      * @param account The address of the account to get the balance of
776      * @return The number of tokens held
777      */
778     function balanceOf(address account) external view returns (uint256) {
779         return balances[account];
780     }
781 
782     /**
783      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
784      * @param dst The address of the destination account
785      * @param amount The number of tokens to transfer
786      * @return Whether or not the transfer succeeded
787      */
788     function transfer(address dst, uint256 amount) external returns (bool) {
789         _transferTokens(msg.sender, dst, amount);
790         return true;
791     }
792 
793     /**
794      * @notice Transfer `amount` tokens from `src` to `dst`
795      * @param src The address of the source account
796      * @param dst The address of the destination account
797      * @param amount The number of tokens to transfer
798      * @return Whether or not the transfer succeeded
799      */
800     function transferFrom(
801         address src,
802         address dst,
803         uint256 amount
804     ) external returns (bool) {
805         address spender = msg.sender;
806         uint256 spenderAllowance = allowances[src][spender];
807 
808         if (spender != src && spenderAllowance != uint256(-1)) {
809             uint256 newAllowance =
810                 spenderAllowance.sub(
811                     amount,
812                     "transferFrom: exceeds spender allowance"
813                 );
814             allowances[src][spender] = newAllowance;
815 
816             emit Approval(src, spender, newAllowance);
817         }
818 
819         _transferTokens(src, dst, amount);
820         return true;
821     }
822 
823     function _transferTokens(
824         address src,
825         address dst,
826         uint256 amount
827     ) internal {
828         require(src != address(0), "_transferTokens: zero address");
829         require(dst != address(0), "_transferTokens: zero address");
830 
831         updateFor(src);
832         updateFor(dst);
833 
834         balances[src] = balances[src].sub(
835             amount,
836             "_transferTokens: exceeds balance"
837         );
838         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
839         emit Transfer(src, dst, amount);
840     }
841 
842     function _getChainId() internal pure returns (uint256) {
843         uint256 chainId;
844         assembly {
845             chainId := chainid()
846         }
847         return chainId;
848     }
849 }