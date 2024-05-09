1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.6;
3 
4 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
5 // Subject to the MIT license.
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
22      * @dev Returns the addition of two unsigned integers, reverting on overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint a, uint b) internal pure returns (uint) {
30         uint c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      * - Addition cannot overflow.
43      */
44     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
45         uint c = a + b;
46         require(c >= a, errorMessage);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot underflow.
58      */
59     function sub(uint a, uint b) internal pure returns (uint) {
60         return sub(a, b, "Uniloan::SafeMath: subtraction underflow");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot underflow.
70      */
71     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
72         require(b <= a, errorMessage);
73         uint c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint a, uint b) internal pure returns (uint) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint c = a * b;
117         require(c / a == b, errorMessage);
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers.
124      * Reverts on division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function div(uint a, uint b) internal pure returns (uint) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers.
139      * Reverts with custom message on division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint a, uint b) internal pure returns (uint) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 interface Governance {
190     function proposeJob(address job) external returns (uint);
191 }
192 
193 interface WETH9 {
194     function deposit() external payable;
195     function balanceOf(address account) external view returns (uint);
196     function approve(address spender, uint amount) external returns (bool);
197 }
198 
199 interface Uniswap {
200     function factory() external pure returns (address);
201     function addLiquidity(
202         address tokenA,
203         address tokenB,
204         uint amountADesired,
205         uint amountBDesired,
206         uint amountAMin,
207         uint amountBMin,
208         address to,
209         uint deadline
210     ) external returns (uint amountA, uint amountB, uint liquidity);
211 }
212 
213 interface UniswapPair {
214     function transfer(address to, uint value) external returns (bool);
215     function transferFrom(address from, address to, uint value) external returns (bool);
216     function balanceOf(address account) external view returns (uint);
217     function approve(address spender, uint amount) external returns (bool);
218     function totalSupply() external view returns (uint);
219 }
220 
221 interface Factory {
222     function getPair(address tokenA, address tokenB) external view returns (address pair);
223 }
224 
225 contract Keep3r {
226     using SafeMath for uint;
227 
228     /// @notice WETH address to liquidity into UNI
229     WETH9 public constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
230 
231     /// @notice UniswapV2Router address
232     Uniswap public constant UNI = Uniswap(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
233 
234     /// @notice EIP-20 token name for this token
235     string public constant name = "Keep3r";
236 
237     /// @notice EIP-20 token symbol for this token
238     string public constant symbol = "KPR";
239 
240     /// @notice EIP-20 token decimals for this token
241     uint8 public constant decimals = 18;
242 
243     /// @notice Total number of tokens in circulation
244     uint public totalSupply = 0; // Initial 0
245     
246     /// @notice A record of each accounts delegate
247     mapping (address => address) public delegates;
248     
249     /// @notice A record of votes checkpoints for each account, by index
250     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
251 
252     /// @notice The number of checkpoints for each account
253     mapping (address => uint32) public numCheckpoints;
254 
255     mapping (address => mapping (address => uint)) internal allowances;
256     mapping (address => uint) internal balances;
257 
258     /// @notice The EIP-712 typehash for the contract's domain
259     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
260 
261     /// @notice The EIP-712 typehash for the delegation struct used by the contract
262     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
263 
264     /// @notice The EIP-712 typehash for the permit struct used by the contract
265     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
266     
267     
268     /// @notice A record of states for signing / validating signatures
269     mapping (address => uint) public nonces;
270 
271     /// @notice An event thats emitted when an account changes its delegate
272     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
273 
274     /// @notice An event thats emitted when a delegate account's vote balance changes
275     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
276     
277     /// @notice A checkpoint for marking number of votes from a given block
278     struct Checkpoint {
279         uint32 fromBlock;
280         uint votes;
281     }
282     
283     /**
284      * @notice Delegate votes from `msg.sender` to `delegatee`
285      * @param delegatee The address to delegate votes to
286      */
287     function delegate(address delegatee) public {
288         return _delegate(msg.sender, delegatee);
289     }
290     
291     /**
292      * @notice Delegates votes from signatory to `delegatee`
293      * @param delegatee The address to delegate votes to
294      * @param nonce The contract state required to match the signature
295      * @param expiry The time at which to expire the signature
296      * @param v The recovery byte of the signature
297      * @param r Half of the ECDSA signature pair
298      * @param s Half of the ECDSA signature pair
299      */
300     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
301         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
302         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
303         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
304         address signatory = ecrecover(digest, v, r, s);
305         require(signatory != address(0), "::delegateBySig: invalid signature");
306         require(nonce == nonces[signatory]++, "::delegateBySig: invalid nonce");
307         require(now <= expiry, "::delegateBySig: signature expired");
308         return _delegate(signatory, delegatee);
309     }
310 
311     /**
312      * @notice Gets the current votes balance for `account`
313      * @param account The address to get votes balance
314      * @return The number of current votes for `account`
315      */
316     function getCurrentVotes(address account) external view returns (uint) {
317         uint32 nCheckpoints = numCheckpoints[account];
318         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
319     }
320 
321     /**
322      * @notice Determine the prior number of votes for an account as of a block number
323      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
324      * @param account The address of the account to check
325      * @param blockNumber The block number to get the vote balance at
326      * @return The number of votes the account had as of the given block
327      */
328     function getPriorVotes(address account, uint blockNumber) public view returns (uint) {
329         require(blockNumber < block.number, "::getPriorVotes: not yet determined");
330 
331         uint32 nCheckpoints = numCheckpoints[account];
332         if (nCheckpoints == 0) {
333             return 0;
334         }
335 
336         // First check most recent balance
337         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
338             return checkpoints[account][nCheckpoints - 1].votes;
339         }
340 
341         // Next check implicit zero balance
342         if (checkpoints[account][0].fromBlock > blockNumber) {
343             return 0;
344         }
345 
346         uint32 lower = 0;
347         uint32 upper = nCheckpoints - 1;
348         while (upper > lower) {
349             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
350             Checkpoint memory cp = checkpoints[account][center];
351             if (cp.fromBlock == blockNumber) {
352                 return cp.votes;
353             } else if (cp.fromBlock < blockNumber) {
354                 lower = center;
355             } else {
356                 upper = center - 1;
357             }
358         }
359         return checkpoints[account][lower].votes;
360     }
361 
362     function _delegate(address delegator, address delegatee) internal {
363         address currentDelegate = delegates[delegator];
364         uint delegatorBalance = bonds[delegator];
365         delegates[delegator] = delegatee;
366 
367         emit DelegateChanged(delegator, currentDelegate, delegatee);
368 
369         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
370     }
371 
372     function _moveDelegates(address srcRep, address dstRep, uint amount) internal {
373         if (srcRep != dstRep && amount > 0) {
374             if (srcRep != address(0)) {
375                 uint32 srcRepNum = numCheckpoints[srcRep];
376                 uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
377                 uint srcRepNew = srcRepOld.sub(amount, "::_moveVotes: vote amount underflows");
378                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
379             }
380 
381             if (dstRep != address(0)) {
382                 uint32 dstRepNum = numCheckpoints[dstRep];
383                 uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
384                 uint dstRepNew = dstRepOld.add(amount);
385                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
386             }
387         }
388     }
389 
390     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {
391       uint32 blockNumber = safe32(block.number, "::_writeCheckpoint: block number exceeds 32 bits");
392 
393       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
394           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
395       } else {
396           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
397           numCheckpoints[delegatee] = nCheckpoints + 1;
398       }
399 
400       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
401     }
402 
403     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
404         require(n < 2**32, errorMessage);
405         return uint32(n);
406     }
407 
408     /// @notice The standard EIP-20 transfer event
409     event Transfer(address indexed from, address indexed to, uint amount);
410 
411     /// @notice The standard EIP-20 approval event
412     event Approval(address indexed owner, address indexed spender, uint amount);
413 
414     /// @notice Submit a job
415     event SubmitJob(address indexed job, address indexed provider, uint block, uint credit);
416 
417     /// @notice Remove credit for a job
418     event RemoveJob(address indexed job, address indexed provider, uint block, uint credit);
419 
420     /// @notice Unbond credit for a job
421     event UnbondJob(address indexed job, address indexed provider, uint block, uint credit);
422 
423     /// @notice Added a Job
424     event JobAdded(address indexed job, uint block, address governance);
425 
426     /// @notice Removed a job
427     event JobRemoved(address indexed job, uint block, address governance);
428 
429     /// @notice Worked a job
430     event KeeperWorked(address indexed job, address indexed keeper, uint block);
431 
432     /// @notice Keeper bonding
433     event KeeperBonding(address indexed keeper, uint block, uint active, uint bond);
434 
435     /// @notice Keeper bonded
436     event KeeperBonded(address indexed keeper, uint block, uint activated, uint bond);
437 
438     /// @notice Keeper unbonding
439     event KeeperUnbonding(address indexed keeper, uint block, uint deactive, uint bond);
440 
441     /// @notice Keeper unbound
442     event KeeperUnbound(address indexed keeper, uint block, uint deactivated, uint bond);
443 
444     /// @notice Keeper slashed
445     event KeeperSlashed(address indexed keeper, address indexed slasher, uint block, uint slash);
446 
447     /// @notice Keeper disputed
448     event KeeperDispute(address indexed keeper, uint block);
449 
450     /// @notice Keeper resolved
451     event KeeperResolved(address indexed keeper, uint block);
452 
453     /// @notice 1 day to bond to become a keeper
454     uint constant public BOND = 3 days;
455     /// @notice 14 days to unbond to remove funds from being a keeper
456     uint constant public UNBOND = 14 days;
457     /// @notice 7 days maximum downtime before being slashed
458     uint constant public DOWNTIME = 7 days;
459 
460     /// @notice 5% of funds slashed for downtime
461     uint constant public DOWNTIMESLASH = 500;
462     uint constant public BASE = 10000;
463 
464     /// @notice tracks all current bondings (time)
465     mapping(address => uint) public bondings;
466     /// @notice tracks all current unbondings (time)
467     mapping(address => uint) public unbondings;
468     /// @notice tracks all current pending bonds (amount)
469     mapping(address => uint) public pendingbonds;
470     /// @notice tracks how much a keeper has bonded
471     mapping(address => uint) public bonds;
472     
473     /// @notice total bonded (totalSupply for bonds)
474     uint public totalBonded = 0;
475     /// @notice tracks when a keeper was first registered
476     mapping(address => uint) public firstSeen;
477 
478     /// @notice tracks if a keeper has a pending dispute
479     mapping(address => bool) public disputes;
480 
481     /// @notice tracks last job performed for a keeper
482     mapping(address => uint) public lastJob;
483     /// @notice tracks the amount of job executions for a keeper
484     mapping(address => uint) public work;
485     /// @notice tracks the total job executions for a keeper
486     mapping(address => uint) public workCompleted;
487     /// @notice list of all jobs registered for the keeper system
488     mapping(address => bool) public jobs;
489     /// @notice the current credit available for a job
490     mapping(address => uint) public credits;
491     /// @notice the balances for the liquidity providers
492     mapping(address => uint) public liquidityProviders;
493     /// @notice tracks the relationship between a liquidityProvider and their job
494     mapping(address => address) public liquidityProvided;
495     /// @notice liquidity unbonding days
496     mapping(address => uint) public liquidityUnbonding;
497     /// @notice job proposal delay
498     mapping(address => uint) public jobProposalDelay;
499     /// @notice liquidity apply date
500     mapping(address => uint) public liquidityApplied;
501 
502     /// @notice list of all current keepers
503     mapping(address => bool) public keepers;
504 
505     /// @notice traversable array of keepers to make external management easier
506     address[] public keeperList;
507 
508     /// @notice governance address for the governance contract
509     address public governance;
510 
511     /// @notice the liquidity token supplied by users paying for jobs
512     UniswapPair public liquidity;
513 
514     constructor() public {
515         // Set governance for this token
516         governance = msg.sender;
517         _mint(msg.sender, 10000e18);
518     }
519 
520     function setup() public payable {
521         require(address(liquidity) == address(0x0), "Keep3r::setup: keep3r already setup");
522         WETH.deposit.value(msg.value)();
523         WETH.approve(address(UNI), msg.value);
524         _mint(address(this), 400e18);
525         allowances[address(this)][address(UNI)] = balances[address(this)];
526 
527         // Setup liquidity pool with initial liquidity 1 ETH : 400 KPR
528         UNI.addLiquidity(address(this), address(WETH), balances[address(this)], WETH.balanceOf(address(this)), 0, 0, msg.sender, now.add(1800));
529         liquidity = UniswapPair(Factory(UNI.factory()).getPair(address(this), address(WETH)));
530     }
531 
532     /**
533      * @notice Allows liquidity providers to submit jobs
534      * @param amount the amount of tokens to mint to treasury
535      * @param job the job to assign credit to
536      * @param amount the amount of liquidity tokens to use
537      */
538     function submitJob(address job, uint amount) external {
539         require(liquidityProvided[msg.sender]==address(0x0), "Keep3r::submitJob: liquidity already provided, please remove first");
540         liquidity.transferFrom(msg.sender, address(this), amount);
541         liquidityProviders[msg.sender] = amount;
542         liquidityProvided[msg.sender] = job;
543         liquidityApplied[msg.sender] = now.add(1 days);
544         if (!jobs[job] && jobProposalDelay[job] < now) {
545             Governance(governance).proposeJob(job);
546             jobProposalDelay[job] = now.add(UNBOND);
547         }
548         emit SubmitJob(job, msg.sender, block.number, amount);
549     }
550 
551     function credit(address provider, address job) external {
552         require(liquidityApplied[provider] != 0, "Keep3r::credit: submitJob first");
553         require(liquidityApplied[provider] < now, "Keep3r::credit: still bonding");
554         uint _liquidity = balances[address(liquidity)];
555         uint _credit = _liquidity.mul(liquidityProviders[provider]).div(liquidity.totalSupply());
556         credits[job] = credits[job].add(_credit.mul(2)); // Double liquidity to account for 50:50
557     }
558 
559     /**
560      * @notice Unbond liquidity for a pending keeper job
561      */
562     function unbondJob() external {
563         liquidityUnbonding[msg.sender] = now.add(UNBOND);
564 
565         emit UnbondJob(liquidityProvided[msg.sender], msg.sender, block.number, liquidityProviders[msg.sender]);
566     }
567 
568     /**
569      * @notice Allows liquidity providers to remove liquidity
570      */
571     function removeJob() external {
572         require(liquidityUnbonding[msg.sender] != 0, "Keep3r::removeJob: unbond first");
573         require(liquidityUnbonding[msg.sender] < now, "Keep3r::removeJob: still unbonding");
574         uint _provided = liquidityProviders[msg.sender];
575         uint _liquidity = balances[address(liquidity)];
576         uint _credit = _liquidity.mul(_provided).div(liquidity.totalSupply());
577         address _job = liquidityProvided[msg.sender];
578         if (_credit > credits[_job]) {
579             credits[_job] = 0;
580         } else {
581             credits[_job].sub(_credit);
582         }
583         liquidity.transfer(msg.sender, _provided);
584         liquidityProviders[msg.sender] = 0;
585         liquidityProvided[msg.sender] = address(0x0);
586 
587         emit RemoveJob(_job, msg.sender, block.number, _provided);
588     }
589 
590     /**
591      * @notice Allows governance to mint new tokens to treasury
592      * @param amount the amount of tokens to mint to treasury
593      */
594     function mint(uint amount) external {
595         require(msg.sender == governance, "Keep3r::mint: governance only");
596         _mint(governance, amount);
597     }
598 
599     function burn(uint amount) external {
600         _burn(msg.sender, amount);
601     }
602 
603     function _mint(address dst, uint amount) internal {
604         // mint the amount
605         totalSupply = totalSupply.add(amount);
606         // transfer the amount to the recipient
607         balances[dst] = balances[dst].add(amount);
608         emit Transfer(address(0), dst, amount);
609     }
610 
611     function _burn(address dst, uint amount) internal {
612         require(dst != address(0), "::_burn: burn from the zero address");
613         balances[dst] = balances[dst].sub(amount, "::_burn: burn amount exceeds balance");
614         totalSupply = totalSupply.sub(amount);
615         emit Transfer(dst, address(0), amount);
616     }
617 
618     /**
619      * @notice Allows keepers to claim for work done
620      */
621     function claim() external {
622         _mint(msg.sender, work[msg.sender]);
623         work[msg.sender] = 0;
624     }
625 
626     /**
627      * @notice Implemented by jobs to show that a keeper performend work
628      * @param keeper address of the keeper that performed the work
629      * @param amount the reward that should be allocated
630      */
631     function workReceipt(address keeper, uint amount) external {
632         require(jobs[msg.sender], "Keep3r::workReceipt: only jobs can approve work");
633         lastJob[keeper] = now;
634         credits[msg.sender] = credits[msg.sender].sub(amount, "Keep3r::workReceipt: insuffient funds to pay keeper");
635         work[keeper] = work[keeper].add(amount);
636         workCompleted[keeper] = workCompleted[keeper].add(amount);
637         emit KeeperWorked(msg.sender, keeper, block.number);
638     }
639 
640     /**
641      * @notice Allows governance to add new job systems
642      * @param job address of the contract for which work should be performed
643      */
644     function addJob(address job) external {
645         require(msg.sender == governance, "Keep3r::addJob: only governance can add jobs");
646         jobs[job] = true;
647         emit JobAdded(job, block.number, msg.sender);
648     }
649 
650     /**
651      * @notice Allows governance to remove a job from the systems
652      * @param job address of the contract for which work should be performed
653      */
654     function removeJob(address job) external {
655         require(msg.sender == governance, "Keep3r::removeJob: only governance can remove jobs");
656         jobs[job] = false;
657         emit JobRemoved(job, block.number, msg.sender);
658     }
659 
660     /**
661      * @notice Allows governance to change governance (for future upgradability)
662      * @param _governance new governance address to set
663      */
664     function setGovernance(address _governance) external {
665         require(msg.sender == governance, "Keep3r::setGovernance: only governance can set");
666         governance = _governance;
667     }
668 
669     /**
670      * @notice confirms if the current keeper is registered, can be used for general (non critical) functions
671      * @return true/false if the address is a keeper
672      */
673     function isKeeper(address keeper) external view returns (bool) {
674         return keepers[keeper];
675     }
676 
677     /**
678      * @notice confirms if the current keeper is registered and has a minimum bond, should be used for protected functions
679      * @return true/false if the address is a keeper and has more than the bond
680      */
681     function isMinKeeper(address keeper, uint minBond, uint completed, uint age) external view returns (bool) {
682         return keepers[keeper]
683                 && bonds[keeper] >= minBond
684                 && workCompleted[keeper] > completed
685                 && now.sub(firstSeen[keeper]) > age;
686     }
687 
688     /**
689      * @notice begin the bonding process for a new keeper
690      */
691     function bond(uint amount) external {
692         require(pendingbonds[msg.sender] == 0, "Keep3r::bond: current pending bond");
693         bondings[msg.sender] = now.add(BOND);
694         pendingbonds[msg.sender] = amount;
695         _transferTokens(msg.sender, address(this), amount);
696         emit KeeperBonding(msg.sender, block.number, bondings[msg.sender], amount);
697     }
698 
699     function getKeepers() external view returns (address[] memory) {
700         return keeperList;
701     }
702 
703     /**
704      * @notice allows a keeper to activate/register themselves after bonding
705      */
706     function activate() external {
707         require(bondings[msg.sender] != 0, "Keep3r::activate: bond first");
708         require(bondings[msg.sender] < now, "Keep3r::activate: still bonding");
709         if (!keepers[msg.sender]) {
710           firstSeen[msg.sender] = now;
711         }
712         keepers[msg.sender] = true;
713         totalBonded = totalBonded.add(pendingbonds[msg.sender]);
714         bonds[msg.sender] = bonds[msg.sender].add(pendingbonds[msg.sender]);
715         pendingbonds[msg.sender] = 0;
716         if (lastJob[msg.sender] == 0) {
717             lastJob[msg.sender] = now;
718             keeperList.push(msg.sender);
719         }
720         emit KeeperBonded(msg.sender, block.number, block.timestamp, bonds[msg.sender]);
721     }
722 
723     /**
724      * @notice begin the unbonding process to stop being a keeper
725      */
726     function unbond() external {
727         keepers[msg.sender] = false;
728         unbondings[msg.sender] = now.add(UNBOND);
729         totalBonded = totalBonded.sub(bonds[msg.sender]);
730         _moveDelegates(delegates[msg.sender], address(0), bonds[msg.sender]);
731         emit KeeperUnbonding(msg.sender, block.number, unbondings[msg.sender], bonds[msg.sender]);
732     }
733 
734     /**
735      * @notice withdraw funds after unbonding has finished
736      */
737     function withdraw() external {
738         require(unbondings[msg.sender] != 0, "Keep3r::withdraw: unbond first");
739         require(unbondings[msg.sender] < now, "Keep3r::withdraw: still unbonding");
740         require(!disputes[msg.sender], "Keep3r::withdraw: pending disputes");
741 
742         _transferTokens(address(this), msg.sender, bonds[msg.sender]);
743         emit KeeperUnbound(msg.sender, block.number, block.timestamp, bonds[msg.sender]);
744         bonds[msg.sender] = 0;
745     }
746 
747     /**
748      * @notice slash a keeper for downtime
749      * @param keeper the address being slashed
750      */
751     function down(address keeper) external {
752         require(keepers[keeper], "Keep3r::down: keeper not registered");
753         require(lastJob[keeper].add(DOWNTIME) < now, "Keep3r::down: keeper safe");
754         uint _slash = bonds[keeper].mul(DOWNTIMESLASH).div(BASE);
755         bonds[keeper] = bonds[keeper].sub(_slash);
756         _mint(msg.sender, 1e18);
757         lastJob[keeper] = now;
758         emit KeeperSlashed(keeper, msg.sender, block.number, _slash);
759     }
760 
761     /**
762      * @notice allows governance to create a dispute for a given keeper
763      * @param keeper the address in dispute
764      */
765     function dispute(address keeper) external returns (uint) {
766         require(msg.sender == governance, "Keep3r::dispute: only governance can dispute");
767         disputes[keeper] = true;
768         emit KeeperDispute(keeper, block.number);
769     }
770 
771     /**
772      * @notice allows governance to slash a keeper based on a dispute
773      * @param keeper the address being slashed
774      * @param amount the amount being slashed
775      */
776     function slash(address keeper, uint amount) external {
777         require(msg.sender == governance, "Keep3r::slash: only governance can resolve");
778         bonds[keeper] = bonds[keeper].sub(amount);
779         disputes[keeper] = false;
780         emit KeeperSlashed(keeper, msg.sender, block.number, amount);
781     }
782 
783     /**
784      * @notice allows governance to resolve a dispute on a keeper
785      * @param keeper the address cleared
786      */
787     function resolve(address keeper) external {
788         require(msg.sender == governance, "Keep3r::resolve: only governance can resolve");
789         disputes[keeper] = false;
790         emit KeeperResolved(keeper, block.number);
791     }
792 
793     /**
794      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
795      * @param account The address of the account holding the funds
796      * @param spender The address of the account spending the funds
797      * @return The number of tokens approved
798      */
799     function allowance(address account, address spender) external view returns (uint) {
800         return allowances[account][spender];
801     }
802 
803     /**
804      * @notice Approve `spender` to transfer up to `amount` from `src`
805      * @dev This will overwrite the approval amount for `spender`
806      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
807      * @param spender The address of the account which may transfer tokens
808      * @param amount The number of tokens that are approved (2^256-1 means infinite)
809      * @return Whether or not the approval succeeded
810      */
811     function approve(address spender, uint amount) public returns (bool) {
812         allowances[msg.sender][spender] = amount;
813 
814         emit Approval(msg.sender, spender, amount);
815         return true;
816     }
817 
818     /**
819      * @notice Triggers an approval from owner to spends
820      * @param owner The address to approve from
821      * @param spender The address to be approved
822      * @param amount The number of tokens that are approved (2^256-1 means infinite)
823      * @param deadline The time at which to expire the signature
824      * @param v The recovery byte of the signature
825      * @param r Half of the ECDSA signature pair
826      * @param s Half of the ECDSA signature pair
827      */
828     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
829         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
830         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
831         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
832         address signatory = ecrecover(digest, v, r, s);
833         require(signatory != address(0), "::permit: invalid signature");
834         require(signatory == owner, "::permit: unauthorized");
835         require(now <= deadline, "::permit: signature expired");
836 
837         allowances[owner][spender] = amount;
838 
839         emit Approval(owner, spender, amount);
840     }
841 
842     /**
843      * @notice Get the number of tokens held by the `account`
844      * @param account The address of the account to get the balance of
845      * @return The number of tokens held
846      */
847     function balanceOf(address account) external view returns (uint) {
848         return balances[account];
849     }
850 
851     /**
852      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
853      * @param dst The address of the destination account
854      * @param amount The number of tokens to transfer
855      * @return Whether or not the transfer succeeded
856      */
857     function transfer(address dst, uint amount) public returns (bool) {
858         _transferTokens(msg.sender, dst, amount);
859         return true;
860     }
861 
862     /**
863      * @notice Transfer `amount` tokens from `src` to `dst`
864      * @param src The address of the source account
865      * @param dst The address of the destination account
866      * @param amount The number of tokens to transfer
867      * @return Whether or not the transfer succeeded
868      */
869     function transferFrom(address src, address dst, uint amount) external returns (bool) {
870         address spender = msg.sender;
871         uint spenderAllowance = allowances[src][spender];
872 
873         if (spender != src && spenderAllowance != uint(-1)) {
874             uint newAllowance = spenderAllowance.sub(amount, "::transferFrom: transfer amount exceeds spender allowance");
875             allowances[src][spender] = newAllowance;
876 
877             emit Approval(src, spender, newAllowance);
878         }
879 
880         _transferTokens(src, dst, amount);
881         return true;
882     }
883 
884     function _transferTokens(address src, address dst, uint amount) internal {
885         require(src != address(0), "::_transferTokens: cannot transfer from the zero address");
886         require(dst != address(0), "::_transferTokens: cannot transfer to the zero address");
887 
888         balances[src] = balances[src].sub(amount, "::_transferTokens: transfer amount exceeds balance");
889         balances[dst] = balances[dst].add(amount, "::_transferTokens: transfer amount overflows");
890         emit Transfer(src, dst, amount);
891     }
892 
893     function getChainId() internal pure returns (uint) {
894         uint chainId;
895         assembly { chainId := chainid() }
896         return chainId;
897     }
898 }