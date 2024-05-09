1 // SPDX-License-Identifier: MIT
2 
3 
4 /**
5  * KP2R.NETWORK
6  * A standard implementation of kp3rv1 protocol
7  * Optimized Dapp
8  * Scalability
9  * Clean & tested code
10  */
11 
12 
13 pragma solidity ^0.6.12;
14 
15 
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint) {
18         uint c = a + b;
19         require(c >= a, "add: +");
20 
21         return c;
22     }
23    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
24         uint c = a + b;
25         require(c >= a, errorMessage);
26 
27         return c;
28     }
29    function sub(uint a, uint b) internal pure returns (uint) {
30         return sub(a, b, "sub: -");
31     }
32    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
33         require(b <= a, errorMessage);
34         uint c = a - b;
35 
36         return c;
37     }
38   function mul(uint a, uint b) internal pure returns (uint) {
39        if (a == 0) {
40             return 0;
41         }
42         uint c = a * b;
43         require(c / a == b, "mul: *");
44 
45         return c;
46     }
47   function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
48        if (a == 0) {
49             return 0;
50         }
51         uint c = a * b;
52         require(c / a == b, errorMessage);
53         return c;
54     }
55   function div(uint a, uint b) internal pure returns (uint) {
56         return div(a, b, "div: /");
57     }
58   function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
59         require(b > 0, errorMessage);
60         uint c = a / b;
61         return c;
62     }
63    function mod(uint a, uint b) internal pure returns (uint) {
64         return mod(a, b, "mod: %");
65     }
66   function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 
73 contract ReentrancyGuard {
74    uint256 private constant _NOT_ENTERED = 1;
75     uint256 private constant _ENTERED = 2;
76 
77     uint256 private _status;
78 
79     constructor () internal {
80         _status = _NOT_ENTERED;
81     }
82 
83     modifier nonReentrant() {
84        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
85        _status = _ENTERED;
86        _;
87        _status = _NOT_ENTERED;
88     }
89 }
90 
91 
92 interface IERC20 {
93     function totalSupply() external view returns (uint256);
94     function balanceOf(address account) external view returns (uint256);
95     function transfer(address recipient, uint256 amount) external returns (bool);
96     function allowance(address owner, address spender) external view returns (uint256);
97     function approve(address spender, uint256 amount) external returns (bool);
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101     }
102 
103 library Address {
104     function isContract(address account) internal view returns (bool) {
105         bytes32 codehash;
106         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
107         // solhint-disable-next-line no-inline-assembly
108         assembly { codehash := extcodehash(account) }
109         return (codehash != accountHash && codehash != 0x0);
110     }
111     function toPayable(address account) internal pure returns (address payable) {
112         return address(uint160(account));
113     }
114    function sendValue(address payable recipient, uint256 amount) internal {
115         require(address(this).balance >= amount, "Address: insufficient");
116 
117         // solhint-disable-next-line avoid-call-value
118         (bool success, ) = recipient.call{value:amount}("");
119         require(success, "Address: reverted");
120     }
121 }
122 library SafeERC20 {
123     using SafeMath for uint256;
124     using Address for address;
125 
126     function safeTransfer(IERC20 token, address to, uint256 value) internal {
127         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
128     }
129 
130     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
131         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
132     }
133 
134     function safeApprove(IERC20 token, address spender, uint256 value) internal {
135         // solhint-disable-next-line max-line-length
136         require((value == 0) || (token.allowance(address(this), spender) == 0),
137             "SafeERC20: approve from non-zero to non-zero allowance"
138         );
139         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
140     }
141 
142     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
143         uint256 newAllowance = token.allowance(address(this), spender).add(value);
144         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
145     }
146 
147     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
148         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: < 0");
149         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
150     }
151 
152     function callOptionalReturn(IERC20 token, bytes memory data) private {
153            // solhint-disable-next-line max-line-length
154         require(address(token).isContract(), "SafeERC20: !contract");
155         // solhint-disable-next-line avoid-low-level-calls
156         (bool success, bytes memory returndata) = address(token).call(data);
157         require(success, "SafeERC20: low-level call failed");
158      if (returndata.length > 0) { // Return data is optional
159             // solhint-disable-next-line max-line-length
160             require(abi.decode(returndata, (bool)), "SafeERC20: !succeed");
161         }
162     }
163 }
164 
165 library Keep2rLibrary {
166     function getReserve(address pair, address reserve) external view returns (uint) {
167         (uint _r0, uint _r1,) = IUniswapV2Pair(pair).getReserves();
168         if (IUniswapV2Pair(pair).token0() == reserve) {
169             return _r0;
170         } else if (IUniswapV2Pair(pair).token1() == reserve) {
171             return _r1;
172         } else {
173             return 0;
174         }
175     }
176 }
177 
178 interface IUniswapV2Pair {
179     event Approval(address indexed owner, address indexed spender, uint value);
180     event Transfer(address indexed from, address indexed to, uint value);
181 
182     function name() external pure returns (string memory);
183     function symbol() external pure returns (string memory);
184     function decimals() external pure returns (uint8);
185     function totalSupply() external view returns (uint);
186     function balanceOf(address owner) external view returns (uint);
187     function allowance(address owner, address spender) external view returns (uint);
188 
189     function approve(address spender, uint value) external returns (bool);
190     function transfer(address to, uint value) external returns (bool);
191     function transferFrom(address from, address to, uint value) external returns (bool);
192 
193     function DOMAIN_SEPARATOR() external view returns (bytes32);
194     function PERMIT_TYPEHASH() external pure returns (bytes32);
195     function nonces(address owner) external view returns (uint);
196 
197     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
198 
199     event Mint(address indexed sender, uint amount0, uint amount1);
200     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
201     event Swap(
202         address indexed sender,
203         uint amount0In,
204         uint amount1In,
205         uint amount0Out,
206         uint amount1Out,
207         address indexed to
208     );
209     event Sync(uint112 reserve0, uint112 reserve1);
210 
211     function MINIMUM_LIQUIDITY() external pure returns (uint);
212     function factory() external view returns (address);
213     function token0() external view returns (address);
214     function token1() external view returns (address);
215     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
216     function price0CumulativeLast() external view returns (uint);
217     function price1CumulativeLast() external view returns (uint);
218     function kLast() external view returns (uint);
219 
220     function mint(address to) external returns (uint liquidity);
221     function burn(address to) external returns (uint amount0, uint amount1);
222     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
223     function skim(address to) external;
224     function sync() external;
225 
226     function initialize(address, address) external;
227 }
228 
229 interface IGovernance {
230     function proposeJob(address job) external;
231 }
232 
233 interface IKeep2rHelper {
234     function getQuoteLimit(uint gasUsed) external view returns (uint);
235 }
236 
237 contract Keep2r is ReentrancyGuard {
238     using SafeMath for uint;
239     using SafeERC20 for IERC20;
240 
241     /// @notice Keep3r Helper to set max prices for the ecosystem
242     IKeep2rHelper public KPRH;
243 
244     /// @notice EIP-20 token name for this token
245     string public constant name = "KP2R.Network";
246 
247     /// @notice EIP-20 token symbol for this token
248     string public constant symbol = "KP2R";
249 
250     /// @notice EIP-20 token decimals for this token
251     uint8 public constant decimals = 18;
252 
253     /// @notice Total number of tokens in circulation
254     uint public totalSupply = 0; // Initial 0
255 
256     /// @notice A record of each accounts delegate
257     mapping (address => address) public delegates;
258 
259     /// @notice A record of votes checkpoints for each account, by index
260     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
261 
262     /// @notice The number of checkpoints for each account
263     mapping (address => uint32) public numCheckpoints;
264 
265     mapping (address => mapping (address => uint)) internal allowances;
266     mapping (address => uint) internal balances;
267 
268     /// @notice The EIP-712 typehash for the contract's domain
269     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
270     bytes32 public immutable DOMAINSEPARATOR;
271 
272     /// @notice The EIP-712 typehash for the delegation struct used by the contract
273     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
274 
275     /// @notice The EIP-712 typehash for the permit struct used by the contract
276     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
277 
278 
279     /// @notice A record of states for signing / validating signatures
280     mapping (address => uint) public nonces;
281 
282     /// @notice An event thats emitted when an account changes its delegate
283     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
284 
285     /// @notice An event thats emitted when a delegate account's vote balance changes
286     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
287 
288     /// @notice A checkpoint for marking number of votes from a given block
289     struct Checkpoint {
290         uint32 fromBlock;
291         uint votes;
292     }
293 
294     function delegate(address delegatee) public {
295         _delegate(msg.sender, delegatee);
296     }
297 
298     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
299         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
300         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
301         address signatory = ecrecover(digest, v, r, s);
302         require(signatory != address(0), "delegateBySig: sig");
303         require(nonce == nonces[signatory]++, "delegateBySig: nonce");
304         require(now <= expiry, "delegateBySig: expired");
305         _delegate(signatory, delegatee);
306     }
307 
308   
309     function getCurrentVotes(address account) external view returns (uint) {
310         uint32 nCheckpoints = numCheckpoints[account];
311         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
312     }
313 
314     function getPriorVotes(address account, uint blockNumber) public view returns (uint) {
315         require(blockNumber < block.number, "getPriorVotes:");
316 
317         uint32 nCheckpoints = numCheckpoints[account];
318         if (nCheckpoints == 0) {
319             return 0;
320         }
321 
322         // First check most recent balance
323         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
324             return checkpoints[account][nCheckpoints - 1].votes;
325         }
326 
327         // Next check implicit zero balance
328         if (checkpoints[account][0].fromBlock > blockNumber) {
329             return 0;
330         }
331 
332         uint32 lower = 0;
333         uint32 upper = nCheckpoints - 1;
334         while (upper > lower) {
335             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
336             Checkpoint memory cp = checkpoints[account][center];
337             if (cp.fromBlock == blockNumber) {
338                 return cp.votes;
339             } else if (cp.fromBlock < blockNumber) {
340                 lower = center;
341             } else {
342                 upper = center - 1;
343             }
344         }
345         return checkpoints[account][lower].votes;
346     }
347 
348     function _delegate(address delegator, address delegatee) internal {
349         address currentDelegate = delegates[delegator];
350         uint delegatorBalance = votes[delegator].add(bonds[delegator][address(this)]);
351         delegates[delegator] = delegatee;
352 
353         emit DelegateChanged(delegator, currentDelegate, delegatee);
354 
355         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
356     }
357 
358     function _moveDelegates(address srcRep, address dstRep, uint amount) internal {
359         if (srcRep != dstRep && amount > 0) {
360             if (srcRep != address(0)) {
361                 uint32 srcRepNum = numCheckpoints[srcRep];
362                 uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
363                 uint srcRepNew = srcRepOld.sub(amount, "_moveVotes: underflows");
364                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
365             }
366 
367             if (dstRep != address(0)) {
368                 uint32 dstRepNum = numCheckpoints[dstRep];
369                 uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
370                 uint dstRepNew = dstRepOld.add(amount);
371                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
372             }
373         }
374     }
375 
376     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {
377       uint32 blockNumber = safe32(block.number, "_writeCheckpoint: 32 bits");
378 
379       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
380           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
381       } else {
382           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
383           numCheckpoints[delegatee] = nCheckpoints + 1;
384       }
385 
386       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
387     }
388 
389     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
390         require(n < 2**32, errorMessage);
391         return uint32(n);
392     }
393 
394     /// @notice The standard EIP-20 transfer event
395     event Transfer(address indexed from, address indexed to, uint amount);
396 
397     /// @notice The standard EIP-20 approval event
398     event Approval(address indexed owner, address indexed spender, uint amount);
399 
400     /// @notice Submit a job
401     event SubmitJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
402 
403     /// @notice Apply credit to a job
404     event ApplyCredit(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
405 
406     /// @notice Remove credit for a job
407     event RemoveJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
408 
409     /// @notice Unbond credit for a job
410     event UnbondJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
411 
412     /// @notice Added a Job
413     event JobAdded(address indexed job, uint block, address governance);
414 
415     /// @notice Removed a job
416     event JobRemoved(address indexed job, uint block, address governance);
417 
418     /// @notice Worked a job
419     event KeeperWorked(address indexed credit, address indexed job, address indexed keeper, uint block, uint amount);
420 
421     /// @notice Keeper bonding
422     event KeeperBonding(address indexed keeper, uint block, uint active, uint bond);
423 
424     /// @notice Keeper bonded
425     event KeeperBonded(address indexed keeper, uint block, uint activated, uint bond);
426 
427     /// @notice Keeper unbonding
428     event KeeperUnbonding(address indexed keeper, uint block, uint deactive, uint bond);
429 
430     /// @notice Keeper unbound
431     event KeeperUnbound(address indexed keeper, uint block, uint deactivated, uint bond);
432 
433     /// @notice Keeper slashed
434     event KeeperSlashed(address indexed keeper, address indexed slasher, uint block, uint slash);
435 
436     /// @notice Keeper disputed
437     event KeeperDispute(address indexed keeper, uint block);
438 
439     /// @notice Keeper resolved
440     event KeeperResolved(address indexed keeper, uint block);
441 
442     event AddCredit(address indexed credit, address indexed job, address indexed creditor, uint block, uint amount);
443 
444     /// @notice 1 day to bond to become a keeper
445     uint constant public BOND = 3 days;
446     /// @notice 14 days to unbond to remove funds from being a keeper
447     uint constant public UNBOND = 14 days;
448     /// @notice 3 days till liquidity can be bound
449     uint constant public LIQUIDITYBOND = 3 days;
450 
451     /// @notice direct liquidity fee 0.3%
452     uint constant public FEE = 30;
453     uint constant public BASE = 10000;
454 
455     /// @notice address used for ETH transfers
456     address constant public ETH = address(0xE);
457 
458     /// @notice tracks all current bondings (time)
459     mapping(address => mapping(address => uint)) public bondings;
460     /// @notice tracks all current unbondings (time)
461     mapping(address => mapping(address => uint)) public unbondings;
462     /// @notice allows for partial unbonding
463     mapping(address => mapping(address => uint)) public partialUnbonding;
464     /// @notice tracks all current pending bonds (amount)
465     mapping(address => mapping(address => uint)) public pendingbonds;
466     /// @notice tracks how much a keeper has bonded
467     mapping(address => mapping(address => uint)) public bonds;
468     /// @notice tracks underlying votes (that don't have bond)
469     mapping(address => uint) public votes;
470 
471     /// @notice total bonded (totalSupply for bonds)
472     uint public totalBonded = 0;
473     /// @notice tracks when a keeper was first registered
474     mapping(address => uint) public firstSeen;
475 
476     /// @notice tracks if a keeper has a pending dispute
477     mapping(address => bool) public disputes;
478 
479     /// @notice tracks last job performed for a keeper
480     mapping(address => uint) public lastJob;
481     /// @notice tracks the total job executions for a keeper
482     mapping(address => uint) public workCompleted;
483     /// @notice list of all jobs registered for the keeper system
484     mapping(address => bool) public jobs;
485     /// @notice the current credit available for a job
486     mapping(address => mapping(address => uint)) public credits;
487     /// @notice the balances for the liquidity providers
488     mapping(address => mapping(address => mapping(address => uint))) public liquidityProvided;
489     /// @notice liquidity unbonding days
490     mapping(address => mapping(address => mapping(address => uint))) public liquidityUnbonding;
491     /// @notice liquidity unbonding amounts
492     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmountsUnbonding;
493     /// @notice job proposal delay
494     mapping(address => uint) public jobProposalDelay;
495     /// @notice liquidity apply date
496     mapping(address => mapping(address => mapping(address => uint))) public liquidityApplied;
497     /// @notice liquidity amount to apply
498     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmount;
499 
500     /// @notice list of all current keepers
501     mapping(address => bool) public keepers;
502     /// @notice blacklist of keepers not allowed to participate
503     mapping(address => bool) public blacklist;
504 
505     /// @notice traversable array of keepers to make external management easier
506     address[] public keeperList;
507     /// @notice traversable array of jobs to make external management easier
508     address[] public jobList;
509 
510     /// @notice governance address for the governance contract
511     address public governance;
512     address public pendingGovernance;
513 
514     /// @notice the liquidity token supplied by users paying for jobs
515     mapping(address => bool) public liquidityAccepted;
516 
517     address[] public liquidityPairs;
518 
519     uint internal _gasUsed;
520 
521     constructor(address _kph) public {
522         // Set governance for this token
523         governance = msg.sender;
524         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
525         KPRH = IKeep2rHelper(_kph);
526     }
527 
528     /**
529      * @notice Add ETH credit to a job to be paid out for work
530      * @param job the job being credited
531      */
532     function addCreditETH(address job) external payable {
533         require(jobs[job], "addCreditETH: !job");
534         uint _fee = msg.value.mul(FEE).div(BASE);
535         credits[job][ETH] = credits[job][ETH].add(msg.value.sub(_fee));
536         payable(governance).transfer(_fee);
537 
538         emit AddCredit(ETH, job, msg.sender, block.number, msg.value);
539     }
540 
541     function addCredit(address credit, address job, uint amount) external nonReentrant {
542         require(jobs[job], "addCreditETH: !job");
543         uint _before = IERC20(credit).balanceOf(address(this));
544         IERC20(credit).safeTransferFrom(msg.sender, address(this), amount);
545         uint _received = IERC20(credit).balanceOf(address(this)).sub(_before);
546         uint _fee = _received.mul(FEE).div(BASE);
547         credits[job][credit] = credits[job][credit].add(_received.sub(_fee));
548         IERC20(credit).safeTransfer(governance, _fee);
549 
550         emit AddCredit(credit, job, msg.sender, block.number, _received);
551     }
552 
553     function addVotes(address voter, uint amount) external {
554         require(msg.sender == governance, "addVotes: !gov");
555         _activate(voter, address(this));
556         votes[voter] = votes[voter].add(amount);
557         totalBonded = totalBonded.add(amount);
558         _moveDelegates(address(0), delegates[voter], amount);
559     }
560 
561  
562     function removeVotes(address voter, uint amount) external {
563         require(msg.sender == governance, "addVotes: !gov");
564         votes[voter] = votes[voter].sub(amount);
565         totalBonded = totalBonded.sub(amount);
566         _moveDelegates(delegates[voter], address(0), amount);
567     }
568 
569     function addKPRCredit(address job, uint amount) external {
570         require(msg.sender == governance, "addKPRCredit: !gov");
571         require(jobs[job], "addKPRCredit: !job");
572         credits[job][address(this)] = credits[job][address(this)].add(amount);
573         _mint(address(this), amount);
574         emit AddCredit(address(this), job, msg.sender, block.number, amount);
575     }
576 
577  
578     function approveLiquidity(address liquidity) external {
579         require(msg.sender == governance, "approveLiquidity: !gov");
580         require(!liquidityAccepted[liquidity], "approveLiquidity: !pair");
581         liquidityAccepted[liquidity] = true;
582         liquidityPairs.push(liquidity);
583     }
584 
585     function revokeLiquidity(address liquidity) external {
586         require(msg.sender == governance, "revokeLiquidity: !gov");
587         liquidityAccepted[liquidity] = false;
588     }
589 
590     function pairs() external view returns (address[] memory) {
591         return liquidityPairs;
592     }
593 
594   
595     function addLiquidityToJob(address liquidity, address job, uint amount) external nonReentrant {
596         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
597         IERC20(liquidity).safeTransferFrom(msg.sender, address(this), amount);
598         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].add(amount);
599 
600         liquidityApplied[msg.sender][liquidity][job] = now.add(LIQUIDITYBOND);
601         liquidityAmount[msg.sender][liquidity][job] = liquidityAmount[msg.sender][liquidity][job].add(amount);
602 
603         if (!jobs[job] && jobProposalDelay[job] < now) {
604             IGovernance(governance).proposeJob(job);
605             jobProposalDelay[job] = now.add(UNBOND);
606         }
607         emit SubmitJob(job, liquidity, msg.sender, block.number, amount);
608     }
609 
610     function applyCreditToJob(address provider, address liquidity, address job) external {
611         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
612         require(liquidityApplied[provider][liquidity][job] != 0, "credit: no bond");
613         require(liquidityApplied[provider][liquidity][job] < now, "credit: bonding");
614         uint _liquidity = Keep2rLibrary.getReserve(liquidity, address(this));
615         uint _credit = _liquidity.mul(liquidityAmount[provider][liquidity][job]).div(IERC20(liquidity).totalSupply());
616         _mint(address(this), _credit);
617         credits[job][address(this)] = credits[job][address(this)].add(_credit);
618         liquidityAmount[provider][liquidity][job] = 0;
619 
620         emit ApplyCredit(job, liquidity, provider, block.number, _credit);
621     }
622 
623     function unbondLiquidityFromJob(address liquidity, address job, uint amount) external {
624         require(liquidityAmount[msg.sender][liquidity][job] == 0, "credit: pending credit");
625         liquidityUnbonding[msg.sender][liquidity][job] = now.add(UNBOND);
626         liquidityAmountsUnbonding[msg.sender][liquidity][job] = liquidityAmountsUnbonding[msg.sender][liquidity][job].add(amount);
627         require(liquidityAmountsUnbonding[msg.sender][liquidity][job] <= liquidityProvided[msg.sender][liquidity][job], "unbondLiquidityFromJob: insufficient funds");
628 
629         uint _liquidity = Keep2rLibrary.getReserve(liquidity, address(this));
630         uint _credit = _liquidity.mul(amount).div(IERC20(liquidity).totalSupply());
631         if (_credit > credits[job][address(this)]) {
632             _burn(address(this), credits[job][address(this)]);
633             credits[job][address(this)] = 0;
634         } else {
635             _burn(address(this), _credit);
636             credits[job][address(this)] = credits[job][address(this)].sub(_credit);
637         }
638 
639         emit UnbondJob(job, liquidity, msg.sender, block.number, amount);
640     }
641 
642     function removeLiquidityFromJob(address liquidity, address job) external {
643         require(liquidityUnbonding[msg.sender][liquidity][job] != 0, "removeJob: unbond");
644         require(liquidityUnbonding[msg.sender][liquidity][job] < now, "removeJob: unbonding");
645         uint _amount = liquidityAmountsUnbonding[msg.sender][liquidity][job];
646         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].sub(_amount);
647         liquidityAmountsUnbonding[msg.sender][liquidity][job] = 0;
648         IERC20(liquidity).safeTransfer(msg.sender, _amount);
649 
650         emit RemoveJob(job, liquidity, msg.sender, block.number, _amount);
651     }
652 
653     function mint(uint amount) external {
654         require(msg.sender == governance, "mint: !gov");
655         _mint(governance, amount);
656     }
657 
658   
659     function burn(uint amount) external {
660         _burn(msg.sender, amount);
661     }
662 
663     function _mint(address dst, uint amount) internal {
664         totalSupply = totalSupply.add(amount);
665         balances[dst] = balances[dst].add(amount);
666         emit Transfer(address(0), dst, amount);
667     }
668 
669     function _burn(address dst, uint amount) internal {
670         require(dst != address(0), "_burn: zero address");
671         balances[dst] = balances[dst].sub(amount, "_burn: exceeds balance");
672         totalSupply = totalSupply.sub(amount);
673         emit Transfer(dst, address(0), amount);
674     }
675 
676     function worked(address keeper) external {
677         workReceipt(keeper, KPRH.getQuoteLimit(_gasUsed.sub(gasleft())));
678     }
679 
680     function workReceipt(address keeper, uint amount) public {
681         require(jobs[msg.sender], "workReceipt: !job");
682         require(amount <= KPRH.getQuoteLimit(_gasUsed.sub(gasleft())), "workReceipt: max limit");
683         credits[msg.sender][address(this)] = credits[msg.sender][address(this)].sub(amount, "workReceipt: insuffient funds");
684         lastJob[keeper] = now;
685         _reward(keeper, amount);
686         workCompleted[keeper] = workCompleted[keeper].add(amount);
687         emit KeeperWorked(address(this), msg.sender, keeper, block.number, amount);
688     }
689 
690   
691     function receipt(address credit, address keeper, uint amount) external {
692         require(jobs[msg.sender], "receipt: !job");
693         credits[msg.sender][credit] = credits[msg.sender][credit].sub(amount, "workReceipt: insuffient funds");
694         lastJob[keeper] = now;
695         IERC20(credit).safeTransfer(keeper, amount);
696         emit KeeperWorked(credit, msg.sender, keeper, block.number, amount);
697     }
698 
699   
700     function receiptETH(address keeper, uint amount) external {
701         require(jobs[msg.sender], "receipt: !job");
702         credits[msg.sender][ETH] = credits[msg.sender][ETH].sub(amount, "workReceipt: insuffient funds");
703         lastJob[keeper] = now;
704         payable(keeper).transfer(amount);
705         emit KeeperWorked(ETH, msg.sender, keeper, block.number, amount);
706     }
707 
708     function _reward(address _from, uint _amount) internal {
709         bonds[_from][address(this)] = bonds[_from][address(this)].add(_amount);
710         totalBonded = totalBonded.add(_amount);
711         _moveDelegates(address(0), delegates[_from], _amount);
712         emit Transfer(msg.sender, _from, _amount);
713     }
714 
715     function _bond(address bonding, address _from, uint _amount) internal {
716         bonds[_from][bonding] = bonds[_from][bonding].add(_amount);
717         if (bonding == address(this)) {
718             totalBonded = totalBonded.add(_amount);
719             _moveDelegates(address(0), delegates[_from], _amount);
720         }
721     }
722 
723     function _unbond(address bonding, address _from, uint _amount) internal {
724         bonds[_from][bonding] = bonds[_from][bonding].sub(_amount);
725         if (bonding == address(this)) {
726             totalBonded = totalBonded.sub(_amount);
727             _moveDelegates(delegates[_from], address(0), _amount);
728         }
729 
730     }
731 
732     function addJob(address job) external {
733         require(msg.sender == governance, "addJob: !gov");
734         require(!jobs[job], "addJob: job known");
735         jobs[job] = true;
736         jobList.push(job);
737         emit JobAdded(job, block.number, msg.sender);
738     }
739 
740   
741     function getJobs() external view returns (address[] memory) {
742         return jobList;
743     }
744 
745  
746     function removeJob(address job) external {
747         require(msg.sender == governance, "removeJob: !gov");
748         jobs[job] = false;
749         emit JobRemoved(job, block.number, msg.sender);
750     }
751 
752     function setKeep3rHelper(IKeep2rHelper _kprh) external {
753         require(msg.sender == governance, "setKeep3rHelper: !gov");
754         KPRH = _kprh;
755     }
756 
757   
758     function setGovernance(address _governance) external {
759         require(msg.sender == governance, "setGovernance: !gov");
760         pendingGovernance = _governance;
761     }
762 
763     /**
764      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
765      */
766     function acceptGovernance() external {
767         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
768         governance = pendingGovernance;
769     }
770 
771     function isKeeper(address keeper) external returns (bool) {
772         _gasUsed = gasleft();
773         return keepers[keeper];
774     }
775 
776     function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool) {
777         _gasUsed = gasleft();
778         return keepers[keeper]
779                 && bonds[keeper][address(this)].add(votes[keeper]) >= minBond
780                 && workCompleted[keeper] >= earned
781                 && now.sub(firstSeen[keeper]) >= age;
782     }
783 
784   
785     function isBondedKeeper(address keeper, address bond, uint minBond, uint earned, uint age) external returns (bool) {
786         _gasUsed = gasleft();
787         return keepers[keeper]
788                 && bonds[keeper][bond] >= minBond
789                 && workCompleted[keeper] >= earned
790                 && now.sub(firstSeen[keeper]) >= age;
791     }
792 
793  
794     function bond(address bonding, uint amount) external nonReentrant {
795         require(!blacklist[msg.sender], "bond: blacklisted");
796         bondings[msg.sender][bonding] = now.add(BOND);
797         if (bonding == address(this)) {
798             _transferTokens(msg.sender, address(this), amount);
799         } else {
800             uint _before = IERC20(bonding).balanceOf(address(this));
801             IERC20(bonding).safeTransferFrom(msg.sender, address(this), amount);
802             amount = IERC20(bonding).balanceOf(address(this)).sub(_before);
803         }
804         pendingbonds[msg.sender][bonding] = pendingbonds[msg.sender][bonding].add(amount);
805         emit KeeperBonding(msg.sender, block.number, bondings[msg.sender][bonding], amount);
806     }
807 
808    
809     function getKeepers() external view returns (address[] memory) {
810         return keeperList;
811     }
812 
813   
814     function activate(address bonding) external {
815         require(!blacklist[msg.sender], "activate: blacklisted");
816         require(bondings[msg.sender][bonding] != 0 && bondings[msg.sender][bonding] < now, "activate: bonding");
817         _activate(msg.sender, bonding);
818     }
819     
820     function _activate(address keeper, address bonding) internal {
821         if (firstSeen[keeper] == 0) {
822           firstSeen[keeper] = now;
823           keeperList.push(keeper);
824           lastJob[keeper] = now;
825         }
826         keepers[keeper] = true;
827         _bond(bonding, keeper, pendingbonds[keeper][bonding]);
828         pendingbonds[keeper][bonding] = 0;
829         emit KeeperBonded(keeper, block.number, block.timestamp, bonds[keeper][bonding]);
830     }
831 
832   
833     function unbond(address bonding, uint amount) external {
834         unbondings[msg.sender][bonding] = now.add(UNBOND);
835         _unbond(bonding, msg.sender, amount);
836         partialUnbonding[msg.sender][bonding] = partialUnbonding[msg.sender][bonding].add(amount);
837         emit KeeperUnbonding(msg.sender, block.number, unbondings[msg.sender][bonding], amount);
838     }
839 
840   
841     function withdraw(address bonding) external nonReentrant {
842         require(unbondings[msg.sender][bonding] != 0 && unbondings[msg.sender][bonding] < now, "withdraw: unbonding");
843         require(!disputes[msg.sender], "withdraw: disputes");
844 
845         if (bonding == address(this)) {
846             _transferTokens(address(this), msg.sender, partialUnbonding[msg.sender][bonding]);
847         } else {
848             IERC20(bonding).safeTransfer(msg.sender, partialUnbonding[msg.sender][bonding]);
849         }
850         emit KeeperUnbound(msg.sender, block.number, block.timestamp, partialUnbonding[msg.sender][bonding]);
851         partialUnbonding[msg.sender][bonding] = 0;
852     }
853 
854    
855     function dispute(address keeper) external {
856         require(msg.sender == governance, "dispute: !gov");
857         disputes[keeper] = true;
858         emit KeeperDispute(keeper, block.number);
859     }
860 
861   
862     function slash(address bonded, address keeper, uint amount) public nonReentrant {
863         require(msg.sender == governance, "slash: !gov");
864         if (bonded == address(this)) {
865             _transferTokens(address(this), governance, amount);
866         } else {
867             IERC20(bonded).safeTransfer(governance, amount);
868         }
869         _unbond(bonded, keeper, amount);
870         disputes[keeper] = false;
871         emit KeeperSlashed(keeper, msg.sender, block.number, amount);
872     }
873 
874     function revoke(address keeper) external {
875         require(msg.sender == governance, "slash: !gov");
876         keepers[keeper] = false;
877         blacklist[keeper] = true;
878         slash(address(this), keeper, bonds[keeper][address(this)]);
879     }
880 
881   
882     function resolve(address keeper) external {
883         require(msg.sender == governance, "resolve: !gov");
884         disputes[keeper] = false;
885         emit KeeperResolved(keeper, block.number);
886     }
887 
888    
889     function allowance(address account, address spender) external view returns (uint) {
890         return allowances[account][spender];
891     }
892 
893   
894     function approve(address spender, uint amount) public returns (bool) {
895         allowances[msg.sender][spender] = amount;
896 
897         emit Approval(msg.sender, spender, amount);
898         return true;
899     }
900 
901    
902     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
903         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
904         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
905         address signatory = ecrecover(digest, v, r, s);
906         require(signatory != address(0), "permit: signature");
907         require(signatory == owner, "permit: unauthorized");
908         require(now <= deadline, "permit: expired");
909 
910         allowances[owner][spender] = amount;
911 
912         emit Approval(owner, spender, amount);
913     }
914 
915     function balanceOf(address account) external view returns (uint) {
916         return balances[account];
917     }
918 
919     
920     function transfer(address dst, uint amount) public returns (bool) {
921         _transferTokens(msg.sender, dst, amount);
922         return true;
923     }
924 
925   
926     function transferFrom(address src, address dst, uint amount) external returns (bool) {
927         address spender = msg.sender;
928         uint spenderAllowance = allowances[src][spender];
929 
930         if (spender != src && spenderAllowance != uint(-1)) {
931             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
932             allowances[src][spender] = newAllowance;
933 
934             emit Approval(src, spender, newAllowance);
935         }
936 
937         _transferTokens(src, dst, amount);
938         return true;
939     }
940 
941     function _transferTokens(address src, address dst, uint amount) internal {
942         require(src != address(0), "_transferTokens: zero address");
943         require(dst != address(0), "_transferTokens: zero address");
944 
945         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
946         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
947         emit Transfer(src, dst, amount);
948     }
949 
950     function _getChainId() internal pure returns (uint) {
951         uint chainId;
952         assembly { chainId := chainid() }
953         return chainId;
954     }
955 }