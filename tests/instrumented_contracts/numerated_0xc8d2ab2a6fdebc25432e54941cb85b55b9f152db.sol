1 pragma solidity 0.5.17;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // Storage for a GRAP token
162 contract GRAPTokenStorage {
163 
164     using SafeMath for uint256;
165 
166     /**
167      * @dev Guard variable for re-entrancy checks. Not currently used
168      */
169     bool internal _notEntered;
170 
171     /**
172      * @notice EIP-20 token name for this token
173      */
174     string public name;
175 
176     /**
177      * @notice EIP-20 token symbol for this token
178      */
179     string public symbol;
180 
181     /**
182      * @notice EIP-20 token decimals for this token
183      */
184     uint8 public decimals;
185 
186     /**
187      * @notice Governor for this contract
188      */
189     address public gov;
190 
191     /**
192      * @notice Pending governance for this contract
193      */
194     address public pendingGov;
195 
196     /**
197      * @notice Approved rebaser for this contract
198      */
199     address public rebaser;
200 
201     /**
202      * @notice Reserve address of GRAP protocol
203      */
204     address public incentivizer;
205 
206     /**
207      * @notice Total supply of GRAPs
208      */
209     uint256 internal _totalSupply;
210 
211     /**
212      * @notice Internal decimals used to handle scaling factor
213      */
214     uint256 public constant internalDecimals = 10**24;
215 
216     /**
217      * @notice Used for percentage maths
218      */
219     uint256 public constant BASE = 10**18;
220 
221     /**
222      * @notice Scaling factor that adjusts everyone's balances
223      */
224     uint256 public grapsScalingFactor;
225 
226     mapping (address => uint256) internal _grapBalances;
227 
228     mapping (address => mapping (address => uint256)) internal _allowedFragments;
229 
230     uint256 public initSupply;
231 
232 }
233 
234 contract GRAPGovernanceStorage {
235     /// @notice A record of each accounts delegate
236     mapping (address => address) internal _delegates;
237 
238     /// @notice A checkpoint for marking number of votes from a given block
239     struct Checkpoint {
240         uint32 fromBlock;
241         uint256 votes;
242     }
243 
244     /// @notice A record of votes checkpoints for each account, by index
245     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
246 
247     /// @notice The number of checkpoints for each account
248     mapping (address => uint32) public numCheckpoints;
249 
250     /// @notice The EIP-712 typehash for the contract's domain
251     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
252 
253     /// @notice The EIP-712 typehash for the delegation struct used by the contract
254     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
255 
256     /// @notice A record of states for signing / validating signatures
257     mapping (address => uint) public nonces;
258 }
259 
260 contract GRAPTokenInterface is GRAPTokenStorage, GRAPGovernanceStorage {
261 
262     /// @notice An event thats emitted when an account changes its delegate
263     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
264 
265     /// @notice An event thats emitted when a delegate account's vote balance changes
266     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
267 
268     /**
269      * @notice Event emitted when tokens are rebased
270      */
271     event Rebase(uint256 epoch, uint256 prevGrapsScalingFactor, uint256 newGrapsScalingFactor);
272 
273     /*** Gov Events ***/
274 
275     /**
276      * @notice Event emitted when pendingGov is changed
277      */
278     event NewPendingGov(address oldPendingGov, address newPendingGov);
279 
280     /**
281      * @notice Event emitted when gov is changed
282      */
283     event NewGov(address oldGov, address newGov);
284 
285     /**
286      * @notice Sets the rebaser contract
287      */
288     event NewRebaser(address oldRebaser, address newRebaser);
289 
290     /**
291      * @notice Sets the incentivizer contract
292      */
293     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
294 
295     /* - ERC20 Events - */
296 
297     /**
298      * @notice EIP20 Transfer event
299      */
300     event Transfer(address indexed from, address indexed to, uint amount);
301 
302     /**
303      * @notice EIP20 Approval event
304      */
305     event Approval(address indexed owner, address indexed spender, uint amount);
306 
307     /* - Extra Events - */
308     /**
309      * @notice Tokens minted event
310      */
311     event Mint(address to, uint256 amount);
312 
313     // Public functions
314     function totalSupply() external view returns (uint256);
315     function transfer(address to, uint256 value) external returns(bool);
316     function transferFrom(address from, address to, uint256 value) external returns(bool);
317     function balanceOf(address who) external view returns(uint256);
318     function balanceOfUnderlying(address who) external view returns(uint256);
319     function allowance(address owner_, address spender) external view returns(uint256);
320     function approve(address spender, uint256 value) external returns (bool);
321     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
322     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
323     function maxScalingFactor() external view returns (uint256);
324 
325     /* - Governance Functions - */
326     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
327     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
328     function delegate(address delegatee) external;
329     function delegates(address delegator) external view returns (address);
330     function getCurrentVotes(address account) external view returns (uint256);
331 
332     /* - Permissioned/Governance functions - */
333     function mint(address to, uint256 amount) external returns (bool);
334     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
335     function _setRebaser(address rebaser_) external;
336     function _setIncentivizer(address incentivizer_) external;
337     function _setPendingGov(address pendingGov_) external;
338     function _acceptGov() external;
339 }
340 
341 contract GRAPGovernanceToken is GRAPTokenInterface {
342 
343       /// @notice An event thats emitted when an account changes its delegate
344     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
345 
346     /// @notice An event thats emitted when a delegate account's vote balance changes
347     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
348 
349     /**
350      * @notice Delegate votes from `msg.sender` to `delegatee`
351      * @param delegator The address to get delegatee for
352      */
353     function delegates(address delegator)
354         external
355         view
356         returns (address)
357     {
358         return _delegates[delegator];
359     }
360 
361    /**
362     * @notice Delegate votes from `msg.sender` to `delegatee`
363     * @param delegatee The address to delegate votes to
364     */
365     function delegate(address delegatee) external {
366         return _delegate(msg.sender, delegatee);
367     }
368 
369     /**
370      * @notice Delegates votes from signatory to `delegatee`
371      * @param delegatee The address to delegate votes to
372      * @param nonce The contract state required to match the signature
373      * @param expiry The time at which to expire the signature
374      * @param v The recovery byte of the signature
375      * @param r Half of the ECDSA signature pair
376      * @param s Half of the ECDSA signature pair
377      */
378     function delegateBySig(
379         address delegatee,
380         uint nonce,
381         uint expiry,
382         uint8 v,
383         bytes32 r,
384         bytes32 s
385     )
386         external
387     {
388         bytes32 domainSeparator = keccak256(
389             abi.encode(
390                 DOMAIN_TYPEHASH,
391                 keccak256(bytes(name)),
392                 getChainId(),
393                 address(this)
394             )
395         );
396 
397         bytes32 structHash = keccak256(
398             abi.encode(
399                 DELEGATION_TYPEHASH,
400                 delegatee,
401                 nonce,
402                 expiry
403             )
404         );
405 
406         bytes32 digest = keccak256(
407             abi.encodePacked(
408                 "\x19\x01",
409                 domainSeparator,
410                 structHash
411             )
412         );
413 
414         address signatory = ecrecover(digest, v, r, s);
415         require(signatory != address(0), "GRAP::delegateBySig: invalid signature");
416         require(nonce == nonces[signatory]++, "GRAP::delegateBySig: invalid nonce");
417         require(now <= expiry, "GRAP::delegateBySig: signature expired");
418         return _delegate(signatory, delegatee);
419     }
420 
421     /**
422      * @notice Gets the current votes balance for `account`
423      * @param account The address to get votes balance
424      * @return The number of current votes for `account`
425      */
426     function getCurrentVotes(address account)
427         external
428         view
429         returns (uint256)
430     {
431         uint32 nCheckpoints = numCheckpoints[account];
432         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
433     }
434 
435     /**
436      * @notice Determine the prior number of votes for an account as of a block number
437      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
438      * @param account The address of the account to check
439      * @param blockNumber The block number to get the vote balance at
440      * @return The number of votes the account had as of the given block
441      */
442     function getPriorVotes(address account, uint blockNumber)
443         external
444         view
445         returns (uint256)
446     {
447         require(blockNumber < block.number, "GRAP::getPriorVotes: not yet determined");
448 
449         uint32 nCheckpoints = numCheckpoints[account];
450         if (nCheckpoints == 0) {
451             return 0;
452         }
453 
454         // First check most recent balance
455         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
456             return checkpoints[account][nCheckpoints - 1].votes;
457         }
458 
459         // Next check implicit zero balance
460         if (checkpoints[account][0].fromBlock > blockNumber) {
461             return 0;
462         }
463 
464         uint32 lower = 0;
465         uint32 upper = nCheckpoints - 1;
466         while (upper > lower) {
467             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
468             Checkpoint memory cp = checkpoints[account][center];
469             if (cp.fromBlock == blockNumber) {
470                 return cp.votes;
471             } else if (cp.fromBlock < blockNumber) {
472                 lower = center;
473             } else {
474                 upper = center - 1;
475             }
476         }
477         return checkpoints[account][lower].votes;
478     }
479 
480     function _delegate(address delegator, address delegatee)
481         internal
482     {
483         address currentDelegate = _delegates[delegator];
484         uint256 delegatorBalance = _grapBalances[delegator]; // balance of underlying GRAPs (not scaled);
485         _delegates[delegator] = delegatee;
486 
487         emit DelegateChanged(delegator, currentDelegate, delegatee);
488 
489         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
490     }
491 
492     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
493         if (srcRep != dstRep && amount > 0) {
494             if (srcRep != address(0)) {
495                 // decrease old representative
496                 uint32 srcRepNum = numCheckpoints[srcRep];
497                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
498                 uint256 srcRepNew = srcRepOld.sub(amount);
499                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
500             }
501 
502             if (dstRep != address(0)) {
503                 // increase new representative
504                 uint32 dstRepNum = numCheckpoints[dstRep];
505                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
506                 uint256 dstRepNew = dstRepOld.add(amount);
507                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
508             }
509         }
510     }
511 
512     function _writeCheckpoint(
513         address delegatee,
514         uint32 nCheckpoints,
515         uint256 oldVotes,
516         uint256 newVotes
517     )
518         internal
519     {
520         uint32 blockNumber = safe32(block.number, "GRAP::_writeCheckpoint: block number exceeds 32 bits");
521 
522         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
523             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
524         } else {
525             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
526             numCheckpoints[delegatee] = nCheckpoints + 1;
527         }
528 
529         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
530     }
531 
532     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
533         require(n < 2**32, errorMessage);
534         return uint32(n);
535     }
536 
537     function getChainId() internal pure returns (uint) {
538         uint256 chainId;
539         assembly { chainId := chainid() }
540         return chainId;
541     }
542 }
543 
544 /* import "./GRAPTokenInterface.sol"; */
545 contract GRAPToken is GRAPGovernanceToken {
546     // Modifiers
547     modifier onlyGov() {
548         require(msg.sender == gov);
549         _;
550     }
551 
552     modifier onlyRebaser() {
553         require(msg.sender == rebaser);
554         _;
555     }
556 
557     modifier onlyMinter() {
558         require(msg.sender == rebaser || msg.sender == incentivizer || msg.sender == gov, "not minter");
559         _;
560     }
561 
562     modifier validRecipient(address to) {
563         require(to != address(0x0));
564         require(to != address(this));
565         _;
566     }
567 
568     function initialize(
569         string memory name_,
570         string memory symbol_,
571         uint8 decimals_
572     )
573         public
574     {
575         require(grapsScalingFactor == 0, "already initialized");
576         name = name_;
577         symbol = symbol_;
578         decimals = decimals_;
579     }
580 
581     /**
582     * @notice Computes the current totalSupply
583     */
584     function totalSupply()
585         external
586         view
587         returns (uint256)
588     {
589         return _totalSupply.div(10**24/ (BASE));
590     }
591     
592     /**
593     * @notice Computes the current max scaling factor
594     */
595     function maxScalingFactor()
596         external
597         view
598         returns (uint256)
599     {
600         return _maxScalingFactor();
601     }
602 
603     function _maxScalingFactor()
604         internal
605         view
606         returns (uint256)
607     {
608         // scaling factor can only go up to 2**256-1 = initSupply * grapsScalingFactor
609         // this is used to check if grapsScalingFactor will be too high to compute balances when rebasing.
610         return uint256(-1) / initSupply;
611     }
612 
613     /**
614     * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
615     * @dev Limited to onlyMinter modifier
616     */
617     function mint(address to, uint256 amount)
618         external
619         onlyMinter
620         returns (bool)
621     {
622         _mint(to, amount);
623         return true;
624     }
625 
626     function _mint(address to, uint256 amount)
627         internal
628     {
629       // increase totalSupply
630       _totalSupply = _totalSupply.add(amount.mul(10**24/ (BASE)));
631 
632       // get underlying value
633       uint256 grapValue = amount.mul(internalDecimals).div(grapsScalingFactor);
634 
635       // increase initSupply
636       initSupply = initSupply.add(grapValue);
637 
638       // make sure the mint didnt push maxScalingFactor too low
639       require(grapsScalingFactor <= _maxScalingFactor(), "max scaling factor too low");
640 
641       // add balance
642       _grapBalances[to] = _grapBalances[to].add(grapValue);
643       emit Transfer(address(0), to, amount);
644     
645       // add delegates to the minter
646       _moveDelegates(address(0), _delegates[to], grapValue);
647       emit Mint(to, amount);
648     }
649 
650     /* - ERC20 functionality - */
651 
652     /**
653     * @dev Transfer tokens to a specified address.
654     * @param to The address to transfer to.
655     * @param value The amount to be transferred.
656     * @return True on success, false otherwise.
657     */
658     function transfer(address to, uint256 value)
659         external
660         validRecipient(to)
661         returns (bool)
662     {
663         // underlying balance is stored in graps, so divide by current scaling factor
664 
665         // note, this means as scaling factor grows, dust will be untransferrable.
666         // minimum transfer value == grapsScalingFactor / 1e24;
667 
668         // get amount in underlying
669         uint256 grapValue = value.mul(internalDecimals).div(grapsScalingFactor);
670 
671         // sub from balance of sender
672         _grapBalances[msg.sender] = _grapBalances[msg.sender].sub(grapValue);
673 
674         // add to balance of receiver
675         _grapBalances[to] = _grapBalances[to].add(grapValue);
676         emit Transfer(msg.sender, to, value);
677 
678         _moveDelegates(_delegates[msg.sender], _delegates[to], grapValue);
679         return true;
680     }
681 
682     /**
683     * @dev Transfer tokens from one address to another.
684     * @param from The address you want to send tokens from.
685     * @param to The address you want to transfer to.
686     * @param value The amount of tokens to be transferred.
687     */
688     function transferFrom(address from, address to, uint256 value)
689         external
690         validRecipient(to)
691         returns (bool)
692     {
693         // decrease allowance
694         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
695 
696         // get value in graps
697         uint256 grapValue = value.mul(internalDecimals).div(grapsScalingFactor);
698 
699         // sub from from
700         _grapBalances[from] = _grapBalances[from].sub(grapValue);
701         _grapBalances[to] = _grapBalances[to].add(grapValue);
702         emit Transfer(from, to, value);
703 
704         _moveDelegates(_delegates[from], _delegates[to], grapValue);
705         return true;
706     }
707 
708     /**
709     * @param who The address to query.
710     * @return The balance of the specified address.
711     */
712     function balanceOf(address who)
713       external
714       view
715       returns (uint256)
716     {
717       return _grapBalances[who].mul(grapsScalingFactor).div(internalDecimals);
718     }
719 
720     /** @notice Currently returns the internal storage amount
721     * @param who The address to query.
722     * @return The underlying balance of the specified address.
723     */
724     function balanceOfUnderlying(address who)
725       external
726       view
727       returns (uint256)
728     {
729       return _grapBalances[who];
730     }
731 
732     /**
733      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
734      * @param owner_ The address which owns the funds.
735      * @param spender The address which will spend the funds.
736      * @return The number of tokens still available for the spender.
737      */
738     function allowance(address owner_, address spender)
739         external
740         view
741         returns (uint256)
742     {
743         return _allowedFragments[owner_][spender];
744     }
745 
746     /**
747      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
748      * msg.sender. This method is included for ERC20 compatibility.
749      * increaseAllowance and decreaseAllowance should be used instead.
750      * Changing an allowance with this method brings the risk that someone may transfer both
751      * the old and the new allowance - if they are both greater than zero - if a transfer
752      * transaction is mined before the later approve() call is mined.
753      *
754      * @param spender The address which will spend the funds.
755      * @param value The amount of tokens to be spent.
756      */
757     function approve(address spender, uint256 value)
758         external
759         returns (bool)
760     {
761         _allowedFragments[msg.sender][spender] = value;
762         emit Approval(msg.sender, spender, value);
763         return true;
764     }
765 
766     /**
767      * @dev Increase the amount of tokens that an owner has allowed to a spender.
768      * This method should be used instead of approve() to avoid the double approval vulnerability
769      * described above.
770      * @param spender The address which will spend the funds.
771      * @param addedValue The amount of tokens to increase the allowance by.
772      */
773     function increaseAllowance(address spender, uint256 addedValue)
774         external
775         returns (bool)
776     {
777         _allowedFragments[msg.sender][spender] =
778             _allowedFragments[msg.sender][spender].add(addedValue);
779         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
780         return true;
781     }
782 
783     /**
784      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
785      *
786      * @param spender The address which will spend the funds.
787      * @param subtractedValue The amount of tokens to decrease the allowance by.
788      */
789     function decreaseAllowance(address spender, uint256 subtractedValue)
790         external
791         returns (bool)
792     {
793         uint256 oldValue = _allowedFragments[msg.sender][spender];
794         if (subtractedValue >= oldValue) {
795             _allowedFragments[msg.sender][spender] = 0;
796         } else {
797             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
798         }
799         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
800         return true;
801     }
802 
803     /* - Governance Functions - */
804 
805     /** @notice sets the rebaser
806      * @param rebaser_ The address of the rebaser contract to use for authentication.
807      */
808     function _setRebaser(address rebaser_)
809         external
810         onlyGov
811     {
812         address oldRebaser = rebaser;
813         rebaser = rebaser_;
814         emit NewRebaser(oldRebaser, rebaser_);
815     }
816 
817     /** @notice sets the incentivizer
818      * @param incentivizer_ The address of the rebaser contract to use for authentication.
819      */
820     function _setIncentivizer(address incentivizer_)
821         external
822         onlyGov
823     {
824         address oldIncentivizer = incentivizer;
825         incentivizer = incentivizer_;
826         emit NewIncentivizer(oldIncentivizer, incentivizer_);
827     }
828 
829     /** @notice sets the pendingGov
830      * @param pendingGov_ The address of the rebaser contract to use for authentication.
831      */
832     function _setPendingGov(address pendingGov_)
833         external
834         onlyGov
835     {
836         address oldPendingGov = pendingGov;
837         pendingGov = pendingGov_;
838         emit NewPendingGov(oldPendingGov, pendingGov_);
839     }
840 
841     /** @notice lets msg.sender accept governance
842      *
843      */
844     function _acceptGov()
845         external
846     {
847         require(msg.sender == pendingGov, "!pending");
848         address oldGov = gov;
849         gov = pendingGov;
850         pendingGov = address(0);
851         emit NewGov(oldGov, gov);
852     }
853 
854     /* - Extras - */
855 
856     /**
857     * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
858     *
859     * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
860     *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
861     *      and targetRate is CpiOracleRate / baseCpi
862     */
863     function rebase(
864         uint256 epoch,
865         uint256 indexDelta,
866         bool positive
867     )
868         external
869         onlyRebaser
870         returns (uint256)
871     {
872         if (indexDelta == 0) {
873           emit Rebase(epoch, grapsScalingFactor, grapsScalingFactor);
874           return _totalSupply;
875         }
876 
877         uint256 prevGrapsScalingFactor = grapsScalingFactor;
878 
879         if (!positive) {
880            grapsScalingFactor = grapsScalingFactor.mul(BASE.sub(indexDelta)).div(BASE);
881         } else {
882             uint256 newScalingFactor = grapsScalingFactor.mul(BASE.add(indexDelta)).div(BASE);
883             if (newScalingFactor < _maxScalingFactor()) {
884                 grapsScalingFactor = newScalingFactor;
885             } else {
886               grapsScalingFactor = _maxScalingFactor();
887             }
888         }
889 
890         _totalSupply = initSupply.mul(grapsScalingFactor).div(BASE);
891         emit Rebase(epoch, prevGrapsScalingFactor, grapsScalingFactor);
892         return _totalSupply;
893     }
894 }
895 
896 contract GRAP is GRAPToken {
897     /**
898      * @notice Initialize the new money market
899      * @param name_ ERC-20 name of this token
900      * @param symbol_ ERC-20 symbol of this token
901      * @param decimals_ ERC-20 decimal precision of this token
902      */
903     function initialize(
904         string memory name_,
905         string memory symbol_,
906         uint8 decimals_,
907         address initial_owner,
908         uint256 initSupply_
909     )
910         public
911     {
912         require(initSupply_ > 0, "0 init supply");
913 
914         super.initialize(name_, symbol_, decimals_);
915 
916         initSupply = initSupply_.mul(10**24/ (BASE));
917         _totalSupply = initSupply;
918         grapsScalingFactor = BASE;
919         _grapBalances[initial_owner] = initSupply_.mul(10**24 / (BASE));
920 
921         // owner renounces ownership after deployment as they need to set
922         // rebaser and incentivizer
923         // gov = gov_;
924     }
925 }
926 
927 contract GRAPDelegationStorage {
928     /**
929      * @notice Implementation address for this contract
930      */
931     address public implementation;
932 }
933 
934 contract GRAPDelegatorInterface is GRAPDelegationStorage {
935     /**
936      * @notice Emitted when implementation is changed
937      */
938     event NewImplementation(address oldImplementation, address newImplementation);
939 
940     /**
941      * @notice Called by the gov to update the implementation of the delegator
942      * @param implementation_ The address of the new implementation for delegation
943      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
944      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
945      */
946     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
947 }
948 
949 contract GRAPDelegateInterface is GRAPDelegationStorage {
950     /**
951      * @notice Called by the delegator on a delegate to initialize it for duty
952      * @dev Should revert if any issues arise which make it unfit for delegation
953      * @param data The encoded bytes data for any initialization
954      */
955     function _becomeImplementation(bytes memory data) public;
956 
957     /**
958      * @notice Called by the delegator on a delegate to forfeit its responsibility
959      */
960     function _resignImplementation() public;
961 }
962 
963 contract GRAPDelegate is GRAP, GRAPDelegateInterface {
964     /**
965      * @notice Construct an empty delegate
966      */
967     constructor() public {}
968 
969     /**
970      * @notice Called by the delegator on a delegate to initialize it for duty
971      * @param data The encoded bytes data for any initialization
972      */
973     function _becomeImplementation(bytes memory data) public {
974         // Shh -- currently unused
975         data;
976 
977         // Shh -- we don't ever want this hook to be marked pure
978         if (false) {
979             implementation = address(0);
980         }
981 
982         require(msg.sender == gov, "only the gov may call _becomeImplementation");
983     }
984 
985     /**
986      * @notice Called by the delegator on a delegate to forfeit its responsibility
987      */
988     function _resignImplementation() public {
989         // Shh -- we don't ever want this hook to be marked pure
990         if (false) {
991             implementation = address(0);
992         }
993 
994         require(msg.sender == gov, "only the gov may call _resignImplementation");
995     }
996 }
997 
998 contract GRAPDelegator is GRAPTokenInterface, GRAPDelegatorInterface {
999     /**
1000      * @notice Construct a new GRAP
1001      * @param name_ ERC-20 name of this token
1002      * @param symbol_ ERC-20 symbol of this token
1003      * @param decimals_ ERC-20 decimal precision of this token
1004      * @param initSupply_ Initial token amount
1005      * @param implementation_ The address of the implementation the contract delegates to
1006      * @param becomeImplementationData The encoded args for becomeImplementation
1007      */
1008     constructor(
1009         string memory name_,
1010         string memory symbol_,
1011         uint8 decimals_,
1012         uint256 initSupply_,
1013         address implementation_,
1014         bytes memory becomeImplementationData
1015     )
1016         public
1017     {
1018 
1019 
1020         // Creator of the contract is gov during initialization
1021         gov = msg.sender;
1022 
1023         // First delegate gets to initialize the delegator (i.e. storage contract)
1024         delegateTo(
1025             implementation_,
1026             abi.encodeWithSignature(
1027                 "initialize(string,string,uint8,address,uint256)",
1028                 name_,
1029                 symbol_,
1030                 decimals_,
1031                 msg.sender,
1032                 initSupply_
1033             )
1034         );
1035 
1036         // New implementations always get set via the settor (post-initialize)
1037         _setImplementation(implementation_, false, becomeImplementationData);
1038 
1039     }
1040 
1041     /**
1042      * @notice Called by the gov to update the implementation of the delegator
1043      * @param implementation_ The address of the new implementation for delegation
1044      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1045      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1046      */
1047     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
1048         require(msg.sender == gov, "GRAPDelegator::_setImplementation: Caller must be gov");
1049 
1050         if (allowResign) {
1051             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
1052         }
1053 
1054         address oldImplementation = implementation;
1055         implementation = implementation_;
1056 
1057         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
1058 
1059         emit NewImplementation(oldImplementation, implementation);
1060     }
1061 
1062     /**
1063      * @notice Sender supplies assets into the market and receives cTokens in exchange
1064      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1065      * @param mintAmount The amount of the underlying asset to supply
1066      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1067      */
1068     function mint(address to, uint256 mintAmount)
1069         external
1070         returns (bool)
1071     {
1072         to; mintAmount; // Shh
1073         delegateAndReturn();
1074     }
1075 
1076     /**
1077      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1078      * @param dst The address of the destination account
1079      * @param amount The number of tokens to transfer
1080      * @return Whether or not the transfer succeeded
1081      */
1082     function transfer(address dst, uint256 amount)
1083         external
1084         returns (bool)
1085     {
1086         dst; amount; // Shh
1087         delegateAndReturn();
1088     }
1089 
1090     /**
1091      * @notice Transfer `amount` tokens from `src` to `dst`
1092      * @param src The address of the source account
1093      * @param dst The address of the destination account
1094      * @param amount The number of tokens to transfer
1095      * @return Whether or not the transfer succeeded
1096      */
1097     function transferFrom(
1098         address src,
1099         address dst,
1100         uint256 amount
1101     )
1102         external
1103         returns (bool)
1104     {
1105         src; dst; amount; // Shh
1106         delegateAndReturn();
1107     }
1108 
1109     /**
1110      * @notice Approve `spender` to transfer up to `amount` from `src`
1111      * @dev This will overwrite the approval amount for `spender`
1112      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1113      * @param spender The address of the account which may transfer tokens
1114      * @param amount The number of tokens that are approved (-1 means infinite)
1115      * @return Whether or not the approval succeeded
1116      */
1117     function approve(
1118         address spender,
1119         uint256 amount
1120     )
1121         external
1122         returns (bool)
1123     {
1124         spender; amount; // Shh
1125         delegateAndReturn();
1126     }
1127 
1128     /**
1129      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1130      * This method should be used instead of approve() to avoid the double approval vulnerability
1131      * described above.
1132      * @param spender The address which will spend the funds.
1133      * @param addedValue The amount of tokens to increase the allowance by.
1134      */
1135     function increaseAllowance(
1136         address spender,
1137         uint256 addedValue
1138     )
1139         external
1140         returns (bool)
1141     {
1142         spender; addedValue; // Shh
1143         delegateAndReturn();
1144     }
1145 
1146     function totalSupply()
1147         external
1148         view
1149         returns (uint256)
1150     {
1151         delegateToViewAndReturn();
1152     }
1153 
1154     function maxScalingFactor()
1155         external
1156         view
1157         returns (uint256)
1158     {
1159         delegateToViewAndReturn();
1160     }
1161 
1162     function rebase(
1163         uint256 epoch,
1164         uint256 indexDelta,
1165         bool positive
1166     )
1167         external
1168         returns (uint256)
1169     {
1170         epoch; indexDelta; positive;
1171         delegateAndReturn();
1172     }
1173 
1174     /**
1175      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1176      *
1177      * @param spender The address which will spend the funds.
1178      * @param subtractedValue The amount of tokens to decrease the allowance by.
1179      */
1180     function decreaseAllowance(
1181         address spender,
1182         uint256 subtractedValue
1183     )
1184         external
1185         returns (bool)
1186     {
1187         spender; subtractedValue; // Shh
1188         delegateAndReturn();
1189     }
1190 
1191     /**
1192      * @notice Get the current allowance from `owner` for `spender`
1193      * @param owner The address of the account which owns the tokens to be spent
1194      * @param spender The address of the account which may transfer tokens
1195      * @return The number of tokens allowed to be spent (-1 means infinite)
1196      */
1197     function allowance(
1198         address owner,
1199         address spender
1200     )
1201         external
1202         view
1203         returns (uint256)
1204     {
1205         owner; spender; // Shh
1206         delegateToViewAndReturn();
1207     }
1208 
1209     /**
1210      * @notice Get the current allowance from `owner` for `spender`
1211      * @param delegator The address of the account which has designated a delegate
1212      * @return Address of delegatee
1213      */
1214     function delegates(
1215         address delegator
1216     )
1217         external
1218         view
1219         returns (address)
1220     {
1221         delegator; // Shh
1222         delegateToViewAndReturn();
1223     }
1224 
1225     /**
1226      * @notice Get the token balance of the `owner`
1227      * @param owner The address of the account to query
1228      * @return The number of tokens owned by `owner`
1229      */
1230     function balanceOf(address owner)
1231         external
1232         view
1233         returns (uint256)
1234     {
1235         owner; // Shh
1236         delegateToViewAndReturn();
1237     }
1238 
1239     /**
1240      * @notice Currently unused. For future compatability
1241      * @param owner The address of the account to query
1242      * @return The number of underlying tokens owned by `owner`
1243      */
1244     function balanceOfUnderlying(address owner)
1245         external
1246         view
1247         returns (uint256)
1248     {
1249         owner; // Shh
1250         delegateToViewAndReturn();
1251     }
1252 
1253     /*** Gov Functions ***/
1254 
1255     /**
1256       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
1257       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
1258       * @param newPendingGov New pending gov.
1259       */
1260     function _setPendingGov(address newPendingGov)
1261         external
1262     {
1263         newPendingGov; // Shh
1264         delegateAndReturn();
1265     }
1266 
1267     function _setRebaser(address rebaser_)
1268         external
1269     {
1270         rebaser_; // Shh
1271         delegateAndReturn();
1272     }
1273 
1274     function _setIncentivizer(address incentivizer_)
1275         external
1276     {
1277         incentivizer_; // Shh
1278         delegateAndReturn();
1279     }
1280 
1281     /**
1282       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
1283       * @dev Gov function for pending gov to accept role and update gov
1284       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1285       */
1286     function _acceptGov()
1287         external
1288     {
1289         delegateAndReturn();
1290     }
1291 
1292 
1293     function getPriorVotes(address account, uint blockNumber)
1294         external
1295         view
1296         returns (uint256)
1297     {
1298         account; blockNumber;
1299         delegateToViewAndReturn();
1300     }
1301 
1302     function delegateBySig(
1303         address delegatee,
1304         uint nonce,
1305         uint expiry,
1306         uint8 v,
1307         bytes32 r,
1308         bytes32 s
1309     )
1310         external
1311     {
1312         delegatee; nonce; expiry; v; r; s;
1313         delegateAndReturn();
1314     }
1315 
1316     function delegate(address delegatee)
1317         external
1318     {
1319         delegatee;
1320         delegateAndReturn();
1321     }
1322 
1323     function getCurrentVotes(address account)
1324         external
1325         view
1326         returns (uint256)
1327     {
1328         account;
1329         delegateToViewAndReturn();
1330     }
1331 
1332     /**
1333      * @notice Internal method to delegate execution to another contract
1334      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1335      * @param callee The contract to delegatecall
1336      * @param data The raw data to delegatecall
1337      * @return The returned bytes from the delegatecall
1338      */
1339     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
1340         (bool success, bytes memory returnData) = callee.delegatecall(data);
1341         assembly {
1342             if eq(success, 0) {
1343                 revert(add(returnData, 0x20), returndatasize)
1344             }
1345         }
1346         return returnData;
1347     }
1348 
1349     /**
1350      * @notice Delegates execution to the implementation contract
1351      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1352      * @param data The raw data to delegatecall
1353      * @return The returned bytes from the delegatecall
1354      */
1355     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
1356         return delegateTo(implementation, data);
1357     }
1358 
1359     /**
1360      * @notice Delegates execution to an implementation contract
1361      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1362      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1363      * @param data The raw data to delegatecall
1364      * @return The returned bytes from the delegatecall
1365      */
1366     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
1367         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
1368         assembly {
1369             if eq(success, 0) {
1370                 revert(add(returnData, 0x20), returndatasize)
1371             }
1372         }
1373         return abi.decode(returnData, (bytes));
1374     }
1375 
1376     function delegateToViewAndReturn() private view returns (bytes memory) {
1377         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
1378 
1379         assembly {
1380             let free_mem_ptr := mload(0x40)
1381             returndatacopy(free_mem_ptr, 0, returndatasize)
1382 
1383             switch success
1384             case 0 { revert(free_mem_ptr, returndatasize) }
1385             default { return(add(free_mem_ptr, 0x40), returndatasize) }
1386         }
1387     }
1388 
1389     function delegateAndReturn() private returns (bytes memory) {
1390         (bool success, ) = implementation.delegatecall(msg.data);
1391 
1392         assembly {
1393             let free_mem_ptr := mload(0x40)
1394             returndatacopy(free_mem_ptr, 0, returndatasize)
1395 
1396             switch success
1397             case 0 { revert(free_mem_ptr, returndatasize) }
1398             default { return(free_mem_ptr, returndatasize) }
1399         }
1400     }
1401 
1402     /**
1403      * @notice Delegates execution to an implementation contract
1404      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1405      */
1406     function () external payable {
1407         require(msg.value == 0,"GRAPDelegator:fallback: cannot send value to fallback");
1408 
1409         // delegate all other functions to current implementation
1410         delegateAndReturn();
1411     }
1412 }